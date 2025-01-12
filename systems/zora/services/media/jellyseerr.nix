{ config, lib, ... }:
let
  cfg = config.mediaServer;
in
{
  config = lib.mkIf cfg.enable {
    services.jellyseerr.enable = cfg.enable;
    services.jellyseerr.openFirewall = cfg.openPorts;

    proxiedServices.wanted = {
      port = config.services.jellyseerr.port;
    };
  };

  # /var/lib/jellyseerr/settings.json
  # {
  #   "clientId": "",
  #   "vapidPrivate": "",
  #   "vapidPublic": "",
  #   "main": {
  #     "apiKey": "",
  #     "applicationTitle": "Jellyseerr",
  #     "applicationUrl": "",
  #     "csrfProtection": false,
  #     "cacheImages": false,
  #     "defaultPermissions": 160,
  #     "defaultQuotas": {
  #     "movie": {
  #       "quotaLimit": 0,
  #       "quotaDays": 7
  #     },
  #     "tv": {
  #       "quotaLimit": 0,
  #       "quotaDays": 7
  #     }
  #     },
  #     "hideAvailable": false,
  #     "localLogin": true,
  #     "newPlexLogin": true,
  #     "region": "",
  #     "originalLanguage": "",
  #     "trustProxy": false,
  #     "mediaServerType": 2,
  #     "partialRequestsEnabled": true,
  #     "locale": "en"
  #   },
  #   "plex": {
  #     "name": "",
  #     "ip": "",
  #     "port": 32400,
  #     "useSsl": false,
  #     "libraries": []
  #   },
  #   "jellyfin": {
  #     "name": "",
  #     "hostname": "http://localhost:8096",
  #     "externalHostname": "",
  #     "libraries": [
  #     {
  #       "id": "f137a2dd21bbc1b99aa5c0f6bf02a805",
  #       "name": "Movies",
  #       "enabled": true,
  #       "type": "movie"
  #     },
  #     {
  #       "id": "a656b907eb3a73532e40e44b968d0225",
  #       "name": "Shows",
  #       "enabled": true,
  #       "type": "show"
  #     }
  #     ],
  #     "serverId": "766fc950e7c546e6ac3b05414fa4b87b"
  #   },
  #   "tautulli": {},
  #   "radarr": [
  #     {
  #     "name": "home",
  #     "hostname": "localhost",
  #     "port": 7878,
  #     "apiKey": "",
  #     "useSsl": false,
  #     "baseUrl": "",
  #     "activeProfileId": 6,
  #     "activeProfileName": "HD - 720p/1080p",
  #     "activeDirectory": "/data/media/movies",
  #     "is4k": false,
  #     "minimumAvailability": "released",
  #     "tags": [],
  #     "isDefault": true,
  #     "syncEnabled": false,
  #     "preventSearch": false,
  #     "tagRequests": false,
  #     "id": 0
  #     }
  #   ],
  #   "sonarr": [
  #     {
  #     "name": "Home",
  #     "hostname": "localhost",
  #     "port": 8989,
  #     "apiKey": "",
  #     "useSsl": false,
  #     "activeProfileId": 6,
  #     "activeLanguageProfileId": 1,
  #     "activeProfileName": "HD - 720p/1080p",
  #     "activeDirectory": "/data/media/series",
  #     "activeAnimeDirectory": "",
  #     "tags": [],
  #     "animeTags": [],
  #     "is4k": false,
  #     "isDefault": true,
  #     "enableSeasonFolders": true,
  #     "syncEnabled": false,
  #     "preventSearch": false,
  #     "tagRequests": false,
  #     "id": 0
  #     }
  #   ],
  #   "public": {
  #     "initialized": true
  #   },
  #   "notifications": {
  #     "agents": {
  #     "email": {
  #       "enabled": false,
  #       "options": {
  #       "userEmailRequired": false,
  #       "emailFrom": "",
  #       "smtpHost": "",
  #       "smtpPort": 587,
  #       "secure": false,
  #       "ignoreTls": false,
  #       "requireTls": false,
  #       "allowSelfSigned": false,
  #       "senderName": "Jellyseerr"
  #       }
  #     },
  #     "discord": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "webhookUrl": "",
  #       "enableMentions": true
  #       }
  #     },
  #     "lunasea": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "webhookUrl": ""
  #       }
  #     },
  #     "slack": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "webhookUrl": ""
  #       }
  #     },
  #     "telegram": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "botAPI": "",
  #       "chatId": "",
  #       "sendSilently": false
  #       }
  #     },
  #     "pushbullet": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "accessToken": ""
  #       }
  #     },
  #     "pushover": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "accessToken": "",
  #       "userToken": ""
  #       }
  #     },
  #     "webhook": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "webhookUrl": "",
  #       "jsonPayload": "IntcbiAgXCJub3RpZmljYXRpb25fdHlwZVwiOiBcInt7bm90aWZpY2F0aW9uX3R5cGV9fVwiLFxuICBcImV2ZW50XCI6IFwie3tldmVudH19XCIsXG4gIFwic3ViamVjdFwiOiBcInt7c3ViamVjdH19XCIsXG4gIFwibWVzc2FnZVwiOiBcInt7bWVzc2FnZX19XCIsXG4gIFwiaW1hZ2VcIjogXCJ7e2ltYWdlfX1cIixcbiAgXCJ7e21lZGlhfX1cIjoge1xuICAgIFwibWVkaWFfdHlwZVwiOiBcInt7bWVkaWFfdHlwZX19XCIsXG4gICAgXCJ0bWRiSWRcIjogXCJ7e21lZGlhX3RtZGJpZH19XCIsXG4gICAgXCJ0dmRiSWRcIjogXCJ7e21lZGlhX3R2ZGJpZH19XCIsXG4gICAgXCJzdGF0dXNcIjogXCJ7e21lZGlhX3N0YXR1c319XCIsXG4gICAgXCJzdGF0dXM0a1wiOiBcInt7bWVkaWFfc3RhdHVzNGt9fVwiXG4gIH0sXG4gIFwie3tyZXF1ZXN0fX1cIjoge1xuICAgIFwicmVxdWVzdF9pZFwiOiBcInt7cmVxdWVzdF9pZH19XCIsXG4gICAgXCJyZXF1ZXN0ZWRCeV9lbWFpbFwiOiBcInt7cmVxdWVzdGVkQnlfZW1haWx9fVwiLFxuICAgIFwicmVxdWVzdGVkQnlfdXNlcm5hbWVcIjogXCJ7e3JlcXVlc3RlZEJ5X3VzZXJuYW1lfX1cIixcbiAgICBcInJlcXVlc3RlZEJ5X2F2YXRhclwiOiBcInt7cmVxdWVzdGVkQnlfYXZhdGFyfX1cIixcbiAgICBcInJlcXVlc3RlZEJ5X3NldHRpbmdzX2Rpc2NvcmRJZFwiOiBcInt7cmVxdWVzdGVkQnlfc2V0dGluZ3NfZGlzY29yZElkfX1cIixcbiAgICBcInJlcXVlc3RlZEJ5X3NldHRpbmdzX3RlbGVncmFtQ2hhdElkXCI6IFwie3tyZXF1ZXN0ZWRCeV9zZXR0aW5nc190ZWxlZ3JhbUNoYXRJZH19XCJcbiAgfSxcbiAgXCJ7e2lzc3VlfX1cIjoge1xuICAgIFwiaXNzdWVfaWRcIjogXCJ7e2lzc3VlX2lkfX1cIixcbiAgICBcImlzc3VlX3R5cGVcIjogXCJ7e2lzc3VlX3R5cGV9fVwiLFxuICAgIFwiaXNzdWVfc3RhdHVzXCI6IFwie3tpc3N1ZV9zdGF0dXN9fVwiLFxuICAgIFwicmVwb3J0ZWRCeV9lbWFpbFwiOiBcInt7cmVwb3J0ZWRCeV9lbWFpbH19XCIsXG4gICAgXCJyZXBvcnRlZEJ5X3VzZXJuYW1lXCI6IFwie3tyZXBvcnRlZEJ5X3VzZXJuYW1lfX1cIixcbiAgICBcInJlcG9ydGVkQnlfYXZhdGFyXCI6IFwie3tyZXBvcnRlZEJ5X2F2YXRhcn19XCIsXG4gICAgXCJyZXBvcnRlZEJ5X3NldHRpbmdzX2Rpc2NvcmRJZFwiOiBcInt7cmVwb3J0ZWRCeV9zZXR0aW5nc19kaXNjb3JkSWR9fVwiLFxuICAgIFwicmVwb3J0ZWRCeV9zZXR0aW5nc190ZWxlZ3JhbUNoYXRJZFwiOiBcInt7cmVwb3J0ZWRCeV9zZXR0aW5nc190ZWxlZ3JhbUNoYXRJZH19XCJcbiAgfSxcbiAgXCJ7e2NvbW1lbnR9fVwiOiB7XG4gICAgXCJjb21tZW50X21lc3NhZ2VcIjogXCJ7e2NvbW1lbnRfbWVzc2FnZX19XCIsXG4gICAgXCJjb21tZW50ZWRCeV9lbWFpbFwiOiBcInt7Y29tbWVudGVkQnlfZW1haWx9fVwiLFxuICAgIFwiY29tbWVudGVkQnlfdXNlcm5hbWVcIjogXCJ7e2NvbW1lbnRlZEJ5X3VzZXJuYW1lfX1cIixcbiAgICBcImNvbW1lbnRlZEJ5X2F2YXRhclwiOiBcInt7Y29tbWVudGVkQnlfYXZhdGFyfX1cIixcbiAgICBcImNvbW1lbnRlZEJ5X3NldHRpbmdzX2Rpc2NvcmRJZFwiOiBcInt7Y29tbWVudGVkQnlfc2V0dGluZ3NfZGlzY29yZElkfX1cIixcbiAgICBcImNvbW1lbnRlZEJ5X3NldHRpbmdzX3RlbGVncmFtQ2hhdElkXCI6IFwie3tjb21tZW50ZWRCeV9zZXR0aW5nc190ZWxlZ3JhbUNoYXRJZH19XCJcbiAgfSxcbiAgXCJ7e2V4dHJhfX1cIjogW11cbn0i"
  #       }
  #     },
  #     "webpush": {
  #       "enabled": false,
  #       "options": {}
  #     },
  #     "gotify": {
  #       "enabled": false,
  #       "types": 0,
  #       "options": {
  #       "url": "",
  #       "token": ""
  #       }
  #     }
  #     }
  #   },
  #   "jobs": {
  #     "plex-recently-added-scan": {
  #     "schedule": "0 */5 * * * *"
  #     },
  #     "plex-full-scan": {
  #     "schedule": "0 0 3 * * *"
  #     },
  #     "plex-watchlist-sync": {
  #     "schedule": "0 */10 * * * *"
  #     },
  #     "radarr-scan": {
  #     "schedule": "0 0 4 * * *"
  #     },
  #     "sonarr-scan": {
  #     "schedule": "0 30 4 * * *"
  #     },
  #     "availability-sync": {
  #     "schedule": "0 0 5 * * *"
  #     },
  #     "download-sync": {
  #     "schedule": "0 * * * * *"
  #     },
  #     "download-sync-reset": {
  #     "schedule": "0 0 1 * * *"
  #     },
  #     "jellyfin-recently-added-sync": {
  #     "schedule": "0 */5 * * * *"
  #     },
  #     "jellyfin-full-sync": {
  #     "schedule": "0 0 3 * * *"
  #     },
  #     "image-cache-cleanup": {
  #     "schedule": "0 0 5 * * *"
  #     }
  #   }
  #   }
}
