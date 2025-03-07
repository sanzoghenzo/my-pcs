{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mediaServer;
in
  # let
  #   dlnaConfig = ''
  #     <?xml version="1.0" encoding="utf-8"?>
  #     <DlnaOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  #       <EnablePlayTo>true</EnablePlayTo>
  #       <EnableServer>true</EnableServer>
  #       <EnableDebugLog>true</EnableDebugLog>
  #       <EnablePlayToTracing>false</EnablePlayToTracing>
  #       <ClientDiscoveryIntervalSeconds>60</ClientDiscoveryIntervalSeconds>
  #       <AliveMessageIntervalSeconds>120</AliveMessageIntervalSeconds>
  #       <BlastAliveMessageIntervalSeconds>120</BlastAliveMessageIntervalSeconds>
  #       <DefaultUserId>314cb422a691469caf6619ecc3ffe89b</DefaultUserId>
  #       <AutoCreatePlayToProfiles>false</AutoCreatePlayToProfiles>
  #       <BlastAliveMessages>true</BlastAliveMessages>
  #       <SendOnlyMatchedHost>true</SendOnlyMatchedHost>
  #     </DlnaOptions>
  #     '';
  #   encodingConfig = ''
  #     <?xml version="1.0" encoding="utf-8"?>
  #     <EncodingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  #       <EncodingThreadCount>-1</EncodingThreadCount>
  #       <TranscodingTempPath>${config.services.jellyfin.dataDir}/transcodes</TranscodingTempPath>
  #       <FallbackFontPath />
  #       <EnableFallbackFont>false</EnableFallbackFont>
  #       <DownMixAudioBoost>2</DownMixAudioBoost>
  #       <MaxMuxingQueueSize>2048</MaxMuxingQueueSize>
  #       <EnableThrottling>false</EnableThrottling>
  #       <ThrottleDelaySeconds>180</ThrottleDelaySeconds>
  #       <HardwareAccelerationType>qsv</HardwareAccelerationType>
  #       <EncoderAppPathDisplay>${pkgs.jellifin-ffmpeg.path}</EncoderAppPathDisplay>
  #       <VaapiDevice>/dev/dri/renderD128</VaapiDevice>
  #       <EnableTonemapping>false</EnableTonemapping>
  #       <EnableVppTonemapping>false</EnableVppTonemapping>
  #       <TonemappingAlgorithm>bt2390</TonemappingAlgorithm>
  #       <TonemappingMode>auto</TonemappingMode>
  #       <TonemappingRange>auto</TonemappingRange>
  #       <TonemappingDesat>0</TonemappingDesat>
  #       <TonemappingPeak>100</TonemappingPeak>
  #       <TonemappingParam>0</TonemappingParam>
  #       <VppTonemappingBrightness>16</VppTonemappingBrightness>
  #       <VppTonemappingContrast>1</VppTonemappingContrast>
  #       <H264Crf>23</H264Crf>
  #       <H265Crf>28</H265Crf>
  #       <EncoderPreset />
  #       <DeinterlaceDoubleRate>false</DeinterlaceDoubleRate>
  #       <DeinterlaceMethod>yadif</DeinterlaceMethod>
  #       <EnableDecodingColorDepth10Hevc>true</EnableDecodingColorDepth10Hevc>
  #       <EnableDecodingColorDepth10Vp9>false</EnableDecodingColorDepth10Vp9>
  #       <EnableEnhancedNvdecDecoder>true</EnableEnhancedNvdecDecoder>
  #       <PreferSystemNativeHwDecoder>true</PreferSystemNativeHwDecoder>
  #       <EnableIntelLowPowerH264HwEncoder>false</EnableIntelLowPowerH264HwEncoder>
  #       <EnableIntelLowPowerHevcHwEncoder>false</EnableIntelLowPowerHevcHwEncoder>
  #       <EnableHardwareEncoding>true</EnableHardwareEncoding>
  #       <AllowHevcEncoding>false</AllowHevcEncoding>
  #       <EnableSubtitleExtraction>true</EnableSubtitleExtraction>
  #       <HardwareDecodingCodecs>
  #         <string>h264</string>
  #         <string>hevc</string>
  #         <string>mpeg2video</string>
  #         <string>vc1</string>
  #         <string>vp8</string>
  #         <string>vp9</string>
  #       </HardwareDecodingCodecs>
  #       <AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
  #         <string>mkv</string>
  #       </AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
  #     </EncodingOptions>
  #     '';
  #   networkConfig = ''
  #     <?xml version="1.0" encoding="utf-8"?>
  #     <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  #       <RequireHttps>false</RequireHttps>
  #       <CertificatePath />
  #       <CertificatePassword />
  #       <BaseUrl />
  #       <PublicHttpsPort>8920</PublicHttpsPort>
  #       <HttpServerPortNumber>8096</HttpServerPortNumber>
  #       <HttpsPortNumber>8920</HttpsPortNumber>
  #       <EnableHttps>false</EnableHttps>
  #       <PublicPort>8096</PublicPort>
  #       <UPnPCreateHttpPortMap>false</UPnPCreateHttpPortMap>
  #       <UDPPortRange />
  #       <EnableIPV6>false</EnableIPV6>
  #       <EnableIPV4>true</EnableIPV4>
  #       <EnableSSDPTracing>false</EnableSSDPTracing>
  #       <SSDPTracingFilter />
  #       <UDPSendCount>2</UDPSendCount>
  #       <UDPSendDelay>100</UDPSendDelay>
  #       <IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
  #       <VirtualInterfaceNames>vEthernet*</VirtualInterfaceNames>
  #       <GatewayMonitorPeriod>60</GatewayMonitorPeriod>
  #       <TrustAllIP6Interfaces>false</TrustAllIP6Interfaces>
  #       <HDHomerunPortRange />
  #       <PublishedServerUriBySubnet />
  #       <AutoDiscoveryTracing>false</AutoDiscoveryTracing>
  #       <AutoDiscovery>true</AutoDiscovery>
  #       <RemoteIPFilter />
  #       <IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
  #       <EnableUPnP>false</EnableUPnP>
  #       <EnableRemoteAccess>true</EnableRemoteAccess>
  #       <LocalNetworkSubnets />
  #       <LocalNetworkAddresses />
  #       <KnownProxies />
  #       <EnablePublishedServerUriByRequest>false</EnablePublishedServerUriByRequest>
  #     </NetworkConfiguration>
  #     '';
  #   systemConfig = ''
  #     <?xml version="1.0" encoding="utf-8"?>
  #     <ServerConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  #       <LogFileRetentionDays>3</LogFileRetentionDays>
  #       <IsStartupWizardCompleted>true</IsStartupWizardCompleted>
  #       <EnableMetrics>false</EnableMetrics>
  #       <EnableNormalizedItemByNameIds>true</EnableNormalizedItemByNameIds>
  #       <IsPortAuthorized>true</IsPortAuthorized>
  #       <QuickConnectAvailable>true</QuickConnectAvailable>
  #       <EnableCaseSensitiveItemIds>true</EnableCaseSensitiveItemIds>
  #       <DisableLiveTvChannelUserDataName>true</DisableLiveTvChannelUserDataName>
  #       <MetadataPath />
  #       <MetadataNetworkPath />
  #       <PreferredMetadataLanguage>en</PreferredMetadataLanguage>
  #       <MetadataCountryCode>IT</MetadataCountryCode>
  #       <SortReplaceCharacters>
  #         <string>.</string>
  #         <string>+</string>
  #         <string>%</string>
  #       </SortReplaceCharacters>
  #       <SortRemoveCharacters>
  #         <string>,</string>
  #         <string>&amp;</string>
  #         <string>-</string>
  #         <string>{</string>
  #         <string>}</string>
  #         <string>'</string>
  #       </SortRemoveCharacters>
  #       <SortRemoveWords>
  #         <string>the</string>
  #         <string>a</string>
  #         <string>an</string>
  #       </SortRemoveWords>
  #       <MinResumePct>5</MinResumePct>
  #       <MaxResumePct>90</MaxResumePct>
  #       <MinResumeDurationSeconds>300</MinResumeDurationSeconds>
  #       <MinAudiobookResume>5</MinAudiobookResume>
  #       <MaxAudiobookResume>5</MaxAudiobookResume>
  #       <LibraryMonitorDelay>60</LibraryMonitorDelay>
  #       <ImageSavingConvention>Legacy</ImageSavingConvention>
  #       <MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>Book</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>Movie</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>MusicVideo</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers>
  #             <string>The Open Movie Database</string>
  #           </DisabledMetadataFetchers>
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers>
  #             <string>The Open Movie Database</string>
  #           </DisabledImageFetchers>
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>Series</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>MusicAlbum</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers>
  #             <string>TheAudioDB</string>
  #           </DisabledMetadataFetchers>
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>MusicArtist</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers>
  #             <string>TheAudioDB</string>
  #           </DisabledMetadataFetchers>
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>BoxSet</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>Season</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #         <MetadataOptions>
  #           <ItemType>Episode</ItemType>
  #           <DisabledMetadataSavers />
  #           <LocalMetadataReaderOrder />
  #           <DisabledMetadataFetchers />
  #           <MetadataFetcherOrder />
  #           <DisabledImageFetchers />
  #           <ImageFetcherOrder />
  #         </MetadataOptions>
  #       </MetadataOptions>
  #       <SkipDeserializationForBasicTypes>true</SkipDeserializationForBasicTypes>
  #       <ServerName />
  #       <UICulture>en-US</UICulture>
  #       <SaveMetadataHidden>false</SaveMetadataHidden>
  #       <ContentTypes />
  #       <RemoteClientBitrateLimit>0</RemoteClientBitrateLimit>
  #       <EnableFolderView>false</EnableFolderView>
  #       <EnableGroupingIntoCollections>false</EnableGroupingIntoCollections>
  #       <DisplaySpecialsWithinSeasons>true</DisplaySpecialsWithinSeasons>
  #       <CodecsUsed />
  #       <PluginRepositories>
  #         <RepositoryInfo>
  #           <Name>Jellyfin Stable</Name>
  #           <Url>https://repo.jellyfin.org/releases/plugin/manifest-stable.json</Url>
  #           <Enabled>true</Enabled>
  #         </RepositoryInfo>
  #       </PluginRepositories>
  #       <EnableExternalContentInSuggestions>true</EnableExternalContentInSuggestions>
  #       <ImageExtractionTimeoutMs>0</ImageExtractionTimeoutMs>
  #       <PathSubstitutions />
  #       <EnableSlowResponseWarning>true</EnableSlowResponseWarning>
  #       <SlowResponseThresholdMs>500</SlowResponseThresholdMs>
  #       <CorsHosts>
  #         <string>*</string>
  #       </CorsHosts>
  #       <ActivityLogRetentionDays>30</ActivityLogRetentionDays>
  #       <LibraryScanFanoutConcurrency>0</LibraryScanFanoutConcurrency>
  #       <LibraryMetadataRefreshConcurrency>0</LibraryMetadataRefreshConcurrency>
  #       <RemoveOldPlugins>false</RemoveOldPlugins>
  #       <AllowClientLogUpload>true</AllowClientLogUpload>
  #     </ServerConfiguration>
  #     '';
  # in
  {
    config = lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = true;
        group = "multimedia";
        openFirewall = true; # needed for DLNA
      };

      # add hardware decoding
      users.users.jellyfin.extraGroups = ["render"];

      # ${services.jellyfin.configDir}/system.xml (lib.toFile systemConfig)
    };
  }
