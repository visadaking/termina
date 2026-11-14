{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      path = "dNhbcrRJ.Profile 1";

      # declarative prefs (sanitized: excludes passwords/logins/cookies/sessions/sync/account tokens)
      settings = {
        "accessibility.typeaheadfind" = true;
        "accessibility.typeaheadfind.flashBar" = 0;
        "app.shield.optoutstudies.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.ai.control.default" = "blocked";
        "browser.ai.control.linkPreviewKeyPoints" = "blocked";
        "browser.ai.control.pdfjsAltText" = "blocked";
        "browser.ai.control.sidebarChatbot" = "blocked";
        "browser.ai.control.smartTabGroups" = "blocked";
        "browser.ai.control.smartWindow" = "blocked";
        "browser.ai.control.speechRecognition" = "blocked";
        "browser.ai.control.translations" = "blocked";
        "browser.backup.enabled_on.profiles" = "[2]";
        "browser.backup.location" = "/home/visa/Documents/Restore Firefox";
        "browser.backup.scheduled.enabled" = true;
        "browser.bookmarks.editDialog.confirmationHintShowCount" = 3;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.disableResetPrompt" = true;
        "browser.discovery.enabled" = false;
        "browser.download.panel.shown" = true;
        "browser.download.viewableInternally.typeWasRegistered.avif" = true;
        "browser.download.viewableInternally.typeWasRegistered.jxl" = true;
        "browser.download.viewableInternally.typeWasRegistered.webp" = true;
        "browser.eme.ui.firstContentShown" = true;
        "browser.engagement.ctrlTab.has-used" = true;
        "browser.engagement.downloads-button.has-used" = true;
        "browser.engagement.home-button.has-used" = true;
        "browser.ipProtection.added" = true;
        "browser.ipProtection.hasSeenFeature" = true;
        "browser.ipProtection.stateCache" = "unauthenticated";
        "browser.ipProtection.usageCache" = "";
        "browser.keys.openAddons.lastUsed" = "2026-11-04T23:53:05.689Z";
        "browser.link.open_newwindow.override.external" = 7;
        "browser.migrate.interactions.history" = true;
        "browser.migration.version" = 184;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.nimbus" = "copilot-chatbot-sunset:control";
        "browser.ml.chat.page" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.hideLogo" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.nextNumber" = 2;
        "browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.position" = "center";
        "browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.theme" = "dark";
        "browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.uploadedPreviously" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.uuid" =
          "v1-custom-dark-center-1-e636fb5e-cd40-4250-b4d1-eac49792bbf2";
        "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled.migrated" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "custom";
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.widgets.enabled" = false;
        "browser.newtabpage.storageVersion" = 1;
        "browser.nova.enabled" = false;
        "browser.pageActions.persistedActions" =
          "{\"ids\":[\"bookmark\"],\"idsInUrlbar\":[\"bookmark\"],\"idsInUrlbarPreProton\":[],\"version\":1}";
        "browser.pagethumbnails.storage_version" = 3;
        "browser.preferences.config_warning.warningDoH.dismissed" = true;
        "browser.preferences.config_warning.warningExtensionInstall.dismissed" = true;
        "browser.profiles.created" = true;
        "browser.profiles.profile-name.updated" = true;
        "browser.proton.toolbar.version" = 3;
        "browser.rights.3.shown" = true;
        "browser.search.serpEventTelemetryCategorization.regionEnabled" = false;
        "browser.search.totalSearches" = 100;
        "browser.smartwindow.memories.generateFromConversation" = false;
        "browser.smartwindow.memories.generateFromHistory" = false;
        "browser.startup.couldRestoreSession.count" = 2;
        "browser.startup.page" = 3;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "browser.tabs.hoverPreview.showThumbnails" = false;
        "browser.termsofuse.prefMigrationCheck" = true;
        "browser.theme.toolbar-theme" = 0;
        "browser.toolbarbuttons.introduced.sidebar-button" = true;
        "browser.translations.enable" = false;
        "browser.uiCustomization.state" =
          "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"sponsorblocker_ajay_app-browser-action\",\"moz-addon-prod_7tv_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"addon_darkreader_org-browser-action\",\"prathercc_gmail_com-browser-action\",\"librezam_librezam-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"keepassxc-browser_keepassxc_org-browser-action\",\"extension_redact_dev-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"vertical-spacer\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"reset-pbm-toolbar-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"smartwindow-group-tabs-button\",\"ai-window-toggle\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"reset-pbm-toolbar-button\",\"smartwindow-group-tabs-button\",\"ai-window-toggle\",\"developer-button\",\"screenshot-button\",\"ipprotection-button\",\"ublock0_raymondhill_net-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"addon_darkreader_org-browser-action\",\"prathercc_gmail_com-browser-action\",\"librezam_librezam-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"moz-addon-prod_7tv_app-browser-action\",\"keepassxc-browser_keepassxc_org-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"extension_redact_dev-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"TabsToolbar\",\"vertical-tabs\",\"toolbar-menubar\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":28,\"newElementCount\":8}";
        "browser.urlbar.lastUrlbarSearchSeconds" = 1794623971;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.quickactions.timesShownOnboardingLabel" = 2;
        "browser.urlbar.quicksuggest.migrationVersion" = 7;
        "browser.urlbar.recentsearches.lastDefaultChanged" = "1793292859629";
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.showSearchTerms.enabled" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.trustPanel.breachAlerts" = false;
        "browser.warnOnQuitShortcut" = false;
        "devtools.debugger.prefs-schema-version" = 11;
        "devtools.everOpened" = true;
        "devtools.performance.recording.entries" = 134217728;
        "devtools.performance.recording.features" = "[\"screenshots\",\"js\",\"memory\"]";
        "devtools.performance.recording.threads" =
          "[\"GeckoMain\",\"Compositor\",\"Renderer\",\"DOM Worker\"]";
        "devtools.toolbox.selectedTool" = "accessibility";
        "devtools.toolsidebar-height.inspector" = 350;
        "devtools.toolsidebar-width.inspector" = 700;
        "devtools.toolsidebar-width.inspector.splitsidebar" = 350;
        "dom.forms.autocomplete.formautofill" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "extensions.activeThemeID" = "{b6aa7dff-8b85-4733-a064-8e529c5ed419}";
        "extensions.blocklist.pingCountVersion" = -1;
        "extensions.databaseSchema" = 37;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.getAddons.cache.lastUpdate" = 1794595634;
        "extensions.getAddons.databaseSchema" = 6;
        "extensions.lastAppBuildId" = "20261104181552";
        "extensions.lastAppVersion" = "160.0";
        "extensions.lastPlatformVersion" = "160.0";
        "extensions.ml.enabled" = false;
        "extensions.pendingOperations" = false;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
        "extensions.quarantinedDomains.list" =
          "autoatendimento.bb.com.br,ibpf.sicredi.com.br,ibpj.sicredi.com.br,internetbanking.caixa.gov.br,www.ib12.bradesco.com.br,www2.bancobrasil.com.br";
        "extensions.recommendations.hideNotice" = true;
        "extensions.signatureCheckpoint" = 1;
        "extensions.ui.dictionary.hidden" = true;
        "extensions.ui.extension.hidden" = false;
        "extensions.ui.lastCategory" = "addons://list/extension";
        "extensions.ui.locale.hidden" = true;
        "extensions.ui.mlmodel.hidden" = true;
        "extensions.ui.sitepermission.hidden" = true;
        "extensions.ui.theme.hidden" = false;
        "gecko.handlerService.defaultHandlersVersion" = 1;
        "general.autoScroll" = true;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "media.eme.enabled" = true;
        "media.gmp-gmpopenh264.abi" = "x86_64-gcc3";
        "media.gmp-gmpopenh264.hashValue" =
          "f5246bf14d038adf4ce0c4360262ab722bc3de4220f047c3d542b4c564074b4877dc8659e3125c5171c749e7ce93f20cc63777eb5e1539e960670cbc5f30ac85";
        "media.gmp-gmpopenh264.version" = "2.6.0";
        "media.gmp-manager.buildID" = "20261104181552";
        "media.gmp-manager.lastEmptyCheck" = 1794530557;
        "media.gmp-widevinecdm.abi" = "x86_64-gcc3";
        "media.gmp-widevinecdm.hashValue" =
          "4bc44f7e2010ff1dec995ab496702467ec02f45db2f4d977822be89e40043ee0dd75f3d777539ecf243617029bbe5b41a1171d293b2fa615ffeacf5cd7112f29";
        "media.gmp-widevinecdm.version" = "4.10.3112.0";
        "media.gmp.storage.version.observed" = 1;
        "media.peerconnection.ice.default_address_only" = true;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.first-seen-secs" = 1793293299;
        "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;
        "media.webspeech.synth.dont_notify_on_error" = true;
        "messaging-system.activeWebPushSubscriptionCount" = 0;
        "network.cookie.CHIPS.lastMigrateDatabase" = 2;
        "network.cookie.validation.lastEpoch" = 1;
        "network.dns.disablePrefetch" = true;
        "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";
        "network.trr_ui.fallback_was_checked" = false;
        "pdfjs.enableAltText" = false;
        "pdfjs.enabledCache.state" = true;
        "pdfjs.featuresNotificationImpressionCount" = 2;
        "pdfjs.migrationVersion" = 2;
        "privacy.annotate_channels.strict_list.enabled" = true;
        "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = true;
        "privacy.bounceTrackingProtection.mode" = 1;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.was_ever_enabled" = true;
        "privacy.purge_trackers.date_in_cookie_database" = "0";
        "privacy.purge_trackers.last_purge" = "1794578905953";
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.trackingprotection.allow_list.hasMigratedCategoryPrefs" = true;
        "privacy.trackingprotection.allow_list.hasUserInteractedWithETPSettings" = true;
        "privacy.trackingprotection.consentmanager.skip.pbmode.enabled" = false;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "screenshots.browser.component.last-saved-method" = "copy";
        "services.settings.base_attachments_url" =
          "https://firefox.settings.services.mozilla.com/v2|https://firefox-settings-attachments.cdn.mozilla.net/";
        "services.settings.blocklists.addons-bloomfilters.last_check" = 1794617805;
        "services.settings.blocklists.gfx.last_check" = 1794595333;
        "services.settings.last_etag" = "1794619015104";
        "services.settings.security-state.cert-revocations.last_check" = 1794595333;
        "services.settings.security-state.intermediates.last_check" = 1794595333;
        "services.settings.security-state.onecrl.last_check" = 1794595333;
        "sidebar.main.tools" = "opentabs,bookmarks,aichat,history,syncedtabs";
        "sidebar.visibility" = "hide-on-close";
        "toolkit.profiles.newProfileSubmitted" = true;
        "toolkit.profiles.storeID" = "aea2a17d";
        "widget.wayland.session-id" = "ddf09158-ea47-42b0-800d-3e9d4b62173b";
        "xpinstall.whitelist.required" = false;
      };

      # bookmarks (sanitized export; toolbar)
      bookmarks = {
        force = true;
        settings = [
          {
            name = "toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "http://youtube.com/";
                url = "http://youtube.com/";
              }
              {
                name = "https://discord.com/channels/@me";
                url = "https://discord.com/channels/@me";
              }
              {
                name = "https://x.com/home";
                url = "https://x.com/home";
              }
              {
                name = "https://bsky.app/";
                url = "https://bsky.app/";
              }
              {
                name = "https://www.reddit.com/";
                url = "https://www.reddit.com/";
              }
              {
                name = "https://www.twitch.tv/";
                url = "https://www.twitch.tv/";
              }
              {
                name = "https://www.instagram.com/";
                url = "https://www.instagram.com/";
              }
              {
                name = "https://open.spotify.com/";
                url = "https://open.spotify.com/";
              }
              {
                name = "https://soundcloud.com/";
                url = "https://soundcloud.com/";
              }
              {
                name = "https://bandcamp.com/?from=menubar_logo_logged_in";
                url = "https://bandcamp.com/?from=menubar_logo_logged_in";
              }
              {
                name = "https://www.livechart.me/users/visa/library";
                url = "https://www.livechart.me/users/visa/library";
              }
              {
                name = "https://www.miruro.cx/";
                url = "https://www.miruro.cx/";
              }
              {
                name = "https://reanime.to/home";
                url = "https://reanime.to/home";
              }
              {
                name = "https://hianime.at/";
                url = "https://hianime.at/";
              }
              {
                name = "https://kaa.lt/";
                url = "https://kaa.lt/";
              }
              {
                name = "https://store.steampowered.com/";
                url = "https://store.steampowered.com/";
              }
              {
                name = "https://www.roblox.com/";
                url = "https://www.roblox.com/";
              }
              {
                name = "http://fitgirl-repacks.site/";
                url = "http://fitgirl-repacks.site/";
              }
              {
                name = "https://dodi-repacks.site/";
                url = "https://dodi-repacks.site/";
              }
              {
                name = "https://1337x.to/home/";
                url = "https://1337x.to/home/";
              }
              {
                name = "https://steamrip.com/";
                url = "https://steamrip.com/";
              }
              {
                name = "https://nyaa.si/";
                url = "https://nyaa.si/";
              }
              {
                name = "https://web.yts.gg/";
                url = "https://web.yts.gg/";
              }
              {
                name = "https://streamable.com/";
                url = "https://streamable.com/";
              }
              {
                name = "steam status";
                url = "https://steamstat.us/";
              }
              {
                name = "tools";
                bookmarks = [
                  {
                    name = "mobo bios";
                    url = "https://www.asus.com/motherboards-components/motherboards/tuf-gaming/tuf-gaming-b650-plus/helpdesk_bios?model2Name=TUF-GAMING-B650-PLUS";
                  }
                  {
                    name = "mobo bios (home pc)";
                    url = "https://www.gigabyte.com/Motherboard/B760M-DS3H-DDR4-rev-10/support#support-dl-bios";
                  }
                  {
                    name = "cobalt.tools";
                    url = "https://cobalt.tools/";
                  }
                  {
                    name = "8mb.video";
                    url = "https://8mb.video/";
                  }
                  {
                    name = "quickpic";
                    url = "https://quickpic.t3.gg/";
                  }
                  {
                    name = "ASCII converter";
                    url = "https://itoa.hex.dance/";
                  }
                  {
                    name = "vocalremover";
                    url = "https://vocalremover.org/";
                  }
                  {
                    name = "vert.sh";
                    url = "https://vert.sh/convert/";
                  }
                  {
                    name = "zerofs";
                    url = "https://zerofs.link/";
                  }
                  {
                    name = "cheat sheet";
                    url = "https://cheat-sheets.org/";
                  }
                  {
                    name = "export/import discord favourites";
                    url = "https://gist.github.com/Froggeyy/12f9f4627e95e10c6de92b3cd973cf1c";
                  }
                ];
              }
              {
                name = "dashboards";
                bookmarks = [
                  {
                    name = "spotify dashboard";
                    url = "https://artists.spotify.com/c/artist/2Oc03i2OHwokEWR4wIw8qK/home";
                  }
                  {
                    name = "routenote dashboard";
                    url = "https://www.routenote.com/rn/mystats";
                  }
                  {
                    name = "bandcamp dashboard";
                    url = "https://deathpalace.bandcamp.com/stats?from=menubar#zplays";
                  }
                ];
              }
              {
                name = "random stuff";
                bookmarks = [
                  {
                    name = "תאוריה";
                    bookmarks = [
                      {
                        name = "לוח תמרורים";
                        url = "https://xn--9dbimb4cbk.com/all_signs_explanations/";
                      }
                    ];
                  }
                  {
                    name = "random";
                    bookmarks = [
                      {
                        name = "Wotaku.wiki";
                        url = "https://wotaku.wiki/";
                      }
                      {
                        name = "Faithful 32x";
                        url = "https://faithfulpack.net/classic32x";
                      }
                    ];
                  }
                  {
                    name = "future setup upgrade";
                    bookmarks = [
                      {
                        name = "Røde PodMic ";
                        url = "https://ksp.co.il/web/item/341677";
                      }
                      {
                        name = " Keychron C3 Pro ";
                        url = "https://ksp.co.il/web/item/483966";
                      }
                    ];
                  }
                  {
                    name = "idk ";
                    bookmarks = [
                      {
                        name = "pghrt.diy";
                        url = "https://pghrt.diy/";
                      }
                      {
                        name = "transfemscience.org";
                        url = "https://transfemscience.org/";
                      }
                      {
                        name = "hrt.mom";
                        url = "https://scienceclass.pages.gay/";
                      }
                      {
                        name = "valerie.vg";
                        url = "https://valerie.vg/";
                      }
                      {
                        name = "diyhrt.info";
                        url = "https://diyhrt.info/";
                      }
                    ];
                  }
                ];
              }
              {
                name = "Syncthing";
                url = "http://127.0.0.1:8384/";
              }
            ];
          }
        ];
      };
    };
  };
}
