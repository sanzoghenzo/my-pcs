# sanzoghenzo interpretation of aanderse's
# https://gist.github.com/aanderse/19da4d7be57d4e2268f6d25e8b1469b1
# adapted from the excellent NixOS module:
# https://github.com/nix-community/home-manager/blob/master/modules/programs/kodi.nix
# this is intended to use the the kodi-gbm package and no desktop environment.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.kodi;

  stylesheetCommonHeader = ''
    <?xml version="1.0"?>
    <xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
  '';

  stylesheetCommonFooter = "</xsl:stylesheet>";

  stylesheetNestedTags = ''
    <xsl:template match="attr[attrs]">
      <xsl:variable name="elementName" select="@name"/>
      <xsl:element name="{$elementName}">
        <xsl:apply-templates select="attrs" />
      </xsl:element>
    </xsl:template>
    <xsl:template match="attr[list[attrs]]">
    <xsl:variable name="elementName" select="@name"/>
    <xsl:for-each select="list/attrs">
      <xsl:element name="{$elementName}">
        <xsl:apply-templates select="." />
      </xsl:element>
    </xsl:for-each>
    </xsl:template>
    <xsl:template match="attr[not(attrs|list)]">
      <xsl:variable name="elementName" select="@name"/>
      <xsl:element name="{$elementName}">
      <xsl:if test="$elementName='path'">
        <!-- needed in sources.xml but will be used for all "path" tags -->
        <xsl:attribute name="pathversion">1</xsl:attribute>
      </xsl:if>
        <xsl:value-of select="*/@value" />
      </xsl:element>
    </xsl:template>
  '';

  stylesheetTagsAsSettingWithId = ''
    <xsl:template match='attr'>
      <setting>
        <xsl:attribute name="id">
          <xsl:value-of select="@name" />
        </xsl:attribute>
        <xsl:value-of select="*/@value" />
      </setting>
    </xsl:template>
  '';

  stylesheetAdvancedSettingsRootTag = ''
    <xsl:template match='/'>
      <xsl:comment> Generated by NixOS. </xsl:comment>
      <advancedsettings version="1.0">
        <xsl:apply-templates/>
      </advancedsettings>
    </xsl:template>
  '';

  stylesheetSourcesRootTag = ''
    <xsl:template match='/'>
      <xsl:comment> Generated by NixOS. </xsl:comment>
      <sources>
        <xsl:apply-templates/>
      </sources>
    </xsl:template>
  '';

  stylesheetAddonSettingsRootTag = ''
    <xsl:template match='/'>
      <xsl:comment> Generated by NixOS. </xsl:comment>
      <settings version="2">
        <xsl:apply-templates/>
      </settings>
    </xsl:template>
  '';

  attrsetToXml =
    attrs: name: stylesheet:
    pkgs.runCommand name
      {
        # Package splicing for libxslt does not work correctly leading to errors
        # when cross-compiling. Use the version from buildPackages explicitly to
        # fix this.
        nativeBuildInputs = [ pkgs.buildPackages.libxslt.bin ];
        xml = builtins.toXML attrs;
        passAsFile = [ "xml" ];
      }
      ''
        xsltproc ${stylesheet} - < "$xmlPath" > "$out"
      '';

  attrsetToAdvancedSettingsXml =
    attrs: name:
    let
      stylesheet = builtins.toFile "stylesheet.xsl" ''
        ${stylesheetCommonHeader}
        ${stylesheetAdvancedSettingsRootTag}
        ${stylesheetNestedTags}
        ${stylesheetCommonFooter}
      '';
    in
    attrsetToXml attrs name stylesheet;

  attrsetToSourcesXml =
    attrs: name:
    let
      stylesheet = builtins.toFile "stylesheet.xsl" ''
        ${stylesheetCommonHeader}
        ${stylesheetSourcesRootTag}
        ${stylesheetNestedTags}
        ${stylesheetCommonFooter}
      '';
    in
    attrsetToXml attrs name stylesheet;

  attrsetToAddonSettingsXml =
    attrs: name:
    let
      stylesheet = builtins.toFile "stylesheet.xsl" ''
        ${stylesheetCommonHeader}
        ${stylesheetAddonSettingsRootTag}
        ${stylesheetTagsAsSettingWithId}
        ${stylesheetCommonFooter}
      '';
    in
    attrsetToXml attrs name stylesheet;
in
{
  options.services.kodi = {
    enable = lib.mkEnableOption "kodi";

    package = lib.mkPackageOption pkgs "kodi" {
      example = "kodi.withPackages (p: with p; [ jellyfin pvr-iptvsimple vfs-sftp ])";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/kodi";
      description = ''
        Location of the kodi data folder.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "kodi";
      description = ''
        User that will run kodi.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "kodi";
      description = ''
        Group for kodi's data folders.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the specified web server port.
      '';
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            oneOf [
              str
              int
              bool
              (attrsOf valueType)
            ]
            // {
              description = "attribute sets";
            };
        in
        nullOr valueType;
      default = null;
      example = lib.literalExpression ''
        { videolibrary.showemptytvshows = true; }
      '';
      description = ''
        Configuration to write to the `advancedsettings.xml`
        file in kodis userdata directory. Settings specified here will be
        immutable from inside kodi and be hidden from the GUI settings dialog.

        See <https://kodi.wiki/view/Advancedsettings.xml> as
        reference for how settings need to be specified.
      '';
    };

    sources = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            oneOf [
              str
              int
              bool
              (attrsOf valueType)
              (listOf valueType)
            ]
            // {
              description = "attribute sets or lists";
            };
        in
        nullOr valueType;
      default = null;
      example = lib.literalExpression ''
        {
          video = {
            default = "movies";
            source = [
              { name = "videos"; path = "/path/to/videos"; allowsharing = true; }
              { name = "movies"; path = "/path/to/movies"; allowsharing = true; }
            ];
          };
        }
      '';
      description = ''
        Contents to populate the file `sources.xml` in kodis
        userdata directory.

        See <https://kodi.wiki/view/Sources.xml> as
        reference for how sources need to be specified.

        Kodi will still show the dialogs to modify sources in the GUI and they
        appear to be mutable. This however is not the case and the sources will
        stay as specified via NixOS ocnfiguration.
      '';
    };

    addonSettings = lib.mkOption {
      type =
        with lib.types;
        nullOr (
          attrsOf (
            attrsOf (oneOf [
              str
              int
              bool
            ])
          )
        );
      default = null;
      example = lib.literalExpression ''
        { "service.xbmc.versioncheck".versioncheck_enable = "false"; }
      '';
      description = ''
        Attribute set with the plugin namespace as toplevel key and the plugins
        settings as lower level key/value pairs.

        Kodi will still show the settings of plugins configured via this
        mechanism in the GUI and they appear to be mutable. This however is
        not the case and the settings will stay as specified via NixOS configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      (config.services.kodi.settings.services.webserverport or 8080)
    ];

    users.groups = lib.mkIf (cfg.group == "kodi") {
      kodi = { };
    };
    users.users = lib.mkIf (cfg.user == "kodi") {
      kodi = {
        isNormalUser = true;
        group = cfg.group;
        extraGroups = [
          "audio"
          "video"
          "input"
          "render"
        ];
        description = "Kodi player user";
        home = cfg.dataDir;
      };
    };

    systemd.tmpfiles.rules =
      [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/userdata 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/userdata/addon_data 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.dataDir}/addons 0750 ${cfg.user} ${cfg.group} - -"
        "Z ${cfg.dataDir} - ${cfg.user} ${cfg.group} - -"
      ]
      ++ lib.optionals (cfg.settings != null) [
        "L+ ${cfg.dataDir}/userdata/advancedsettings.xml - - - - ${attrsetToAdvancedSettingsXml cfg.settings "kodi-advancedsettings.xml"}"
        "z ${cfg.dataDir}/userdata/advancedsettings.xml - ${cfg.user} ${cfg.group} - -"
      ]
      ++ lib.optionals (cfg.sources != null) [
        "L+ ${cfg.dataDir}/userdata/sources.xml - - - - ${attrsetToSourcesXml cfg.sources "kodi-sources.xml"}"
        "z ${cfg.dataDir}/userdata/sources.xml - ${cfg.user} ${cfg.group} - -"
      ]
      ++ lib.optionals (cfg.addonSettings != null) (
        lib.attrValues (
          lib.mapAttrs (
            k: v:
            "L+ ${cfg.dataDir}/userdata/addon_data/${k}/settings.xml - - - - ${attrsetToAddonSettingsXml v "kodi-addon-${k}-settings.xml"}"
          ) cfg.addonSettings
        )
      );

    # taken from https://github.com/graysky2/kodi-standalone-service
    systemd.services.kodi = {
      description = "kodi media center";
      wantedBy = [ "default.target" ];
      partOf = [ "default.target" ];
      after = [
        "remote-fs.target"
        "systemd-user-sessions.service"
        "nss-lookup.target"
        "sound.target"
        "polkit.service"
        "upower.service"
      ];
      wants = [
        "bluetooth.target"
        "network-online.target"
        "polkit.service"
        "upower.service"
      ];
      conflicts = [ "getty@tty.service" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        TTYPath = "/dev/tty1";
        ExecStart = "${cfg.package}/bin/kodi-standalone";
        Restart = "on-failure";
        TimeoutSec = 15;
        # StandardOutput= "syslog";
        # StandardError= "syslog";
        # SyslogIdentifier= "kodi";
      };
      environment.KODI_DATA = cfg.dataDir;
    };
  };
}