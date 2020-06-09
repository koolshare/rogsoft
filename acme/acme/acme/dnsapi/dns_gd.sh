




<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
  <link rel="dns-prefetch" href="https://github.githubassets.com">
  <link rel="dns-prefetch" href="https://avatars0.githubusercontent.com">
  <link rel="dns-prefetch" href="https://avatars1.githubusercontent.com">
  <link rel="dns-prefetch" href="https://avatars2.githubusercontent.com">
  <link rel="dns-prefetch" href="https://avatars3.githubusercontent.com">
  <link rel="dns-prefetch" href="https://github-cloud.s3.amazonaws.com">
  <link rel="dns-prefetch" href="https://user-images.githubusercontent.com/">



  <link crossorigin="anonymous" media="all" integrity="sha512-BmnGTzITfSCD9SKlVfngZdzNq8Fa33lRq00rF1eRsg4zcCH3VtX8QtS6687+5GdeaVj1LzKyLj6+oXJLcswj6w==" rel="stylesheet" href="https://github.githubassets.com/assets/frameworks-0669c64f32137d2083f522a555f9e065.css" />
  
    <link crossorigin="anonymous" media="all" integrity="sha512-HLwpPbjGriZxrqP35jpzSDUnScRZWkUrw9j49/HFXvQ4a6KfUA9gbcbCe/WLt3UaTYM+mnP4MtvwCmlvDuisdQ==" rel="stylesheet" href="https://github.githubassets.com/assets/github-1cbc293db8c6ae2671aea3f7e63a7348.css" />
    
    
    
    


  <meta name="viewport" content="width=device-width">
  
  <title>acme.sh/dns_gd.sh at master · acmesh-official/acme.sh</title>
    <meta name="description" content="A pure Unix shell script implementing ACME client protocol - acmesh-official/acme.sh">
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub">
  <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub">
  <meta property="fb:app_id" content="1401488693436528">

    <meta name="twitter:image:src" content="https://avatars1.githubusercontent.com/u/60454762?s=400&amp;v=4" /><meta name="twitter:site" content="@github" /><meta name="twitter:card" content="summary" /><meta name="twitter:title" content="acmesh-official/acme.sh" /><meta name="twitter:description" content="A pure Unix shell script implementing ACME client protocol - acmesh-official/acme.sh" />
    <meta property="og:image" content="https://avatars1.githubusercontent.com/u/60454762?s=400&amp;v=4" /><meta property="og:site_name" content="GitHub" /><meta property="og:type" content="object" /><meta property="og:title" content="acmesh-official/acme.sh" /><meta property="og:url" content="https://github.com/acmesh-official/acme.sh" /><meta property="og:description" content="A pure Unix shell script implementing ACME client protocol - acmesh-official/acme.sh" />

  <link rel="assets" href="https://github.githubassets.com/">
    <link rel="web-socket" href="wss://live.github.com/_sockets/VjI6NTAxOTEyMDk3OjA5NGFlNjBmODRmNjU0OGU1NTZiM2ZmYzQ3Njc0YzQyODBmN2NlM2U1NjZlZTEwNGVlNmYwYWY0NzI0MzNjYWM=--2a8a7d2446d655c56b0019a8b3938b2d2e0ab4c1">
  <link rel="sudo-modal" href="/sessions/sudo_modal">

  <meta name="request-id" content="DD1D:6984:7E834D:AA92E4:5EDF54EF" data-pjax-transient="true" /><meta name="html-safe-nonce" content="812cabbe11e2fa7ec55ab6b8b0e6552194b1667b" data-pjax-transient="true" /><meta name="visitor-payload" content="eyJyZWZlcnJlciI6Imh0dHBzOi8vZ2l0aHViLmNvbS9hY21lc2gtb2ZmaWNpYWwvYWNtZS5zaCIsInJlcXVlc3RfaWQiOiJERDFEOjY5ODQ6N0U4MzREOkFBOTJFNDo1RURGNTRFRiIsInZpc2l0b3JfaWQiOiI5MDYwMjM5ODEzMTY2OTczNDAwIiwicmVnaW9uX2VkZ2UiOiJhcC1ub3J0aGVhc3QtMSIsInJlZ2lvbl9yZW5kZXIiOiJpYWQifQ==" data-pjax-transient="true" /><meta name="visitor-hmac" content="fd22bc348d3daf48912acdcb0c19fc1490b130aca6a7253d0cfa61f5d29a8862" data-pjax-transient="true" />



  <meta name="github-keyboard-shortcuts" content="repository,source-code" data-pjax-transient="true" />

  

  <meta name="selected-link" value="repo_source" data-pjax-transient>

    <meta name="google-site-verification" content="c1kuD-K2HIVF635lypcsWPoD4kilo5-jA_wBFyT4uMY">
  <meta name="google-site-verification" content="KT5gs8h0wvaagLKAVWq8bbeNwnZZK1r1XQysX3xurLU">
  <meta name="google-site-verification" content="ZzhVyEFwb7w3e0-uOTltm8Jsck2F5StVihD0exw2fsA">
  <meta name="google-site-verification" content="GXs5KoUUkNCoaAZn7wPN-t01Pywp9M3sEjnt_3_ZWPc">

<meta name="octolytics-host" content="collector.githubapp.com" /><meta name="octolytics-app-id" content="github" /><meta name="octolytics-event-url" content="https://collector.githubapp.com/github-external/browser_event" /><meta name="octolytics-dimension-ga_id" content="" class="js-octo-ga-id" /><meta name="octolytics-actor-id" content="3822774" /><meta name="octolytics-actor-login" content="mu-yu" /><meta name="octolytics-actor-hash" content="7d1a6ed90004287787ad74eec882d19c24ef43ac6d13e32607cccd7c825055d5" />
<meta name="analytics-location" content="/&lt;user-name&gt;/&lt;repo-name&gt;/blob/show" data-pjax-transient="true" />


<meta name="optimizely-sdk-key" content="cowimJNste4j7QnBNCjaw" />

    <meta name="google-analytics" content="UA-3769691-2">

  <meta class="js-ga-set" name="userId" content="633701d2b860ae5ee953fbcf5a86fc2b">

<meta class="js-ga-set" name="dimension1" content="Logged In">



  

      <meta name="hostname" content="github.com">
    <meta name="user-login" content="mu-yu">


      <meta name="expected-hostname" content="github.com">

      <meta name="js-proxy-site-detection-payload" content="N2NlOGYxOGU1NWEzN2IzM2Q2ODA5M2I3NTcyYzdlYzkxYjE4NDE1YmQ4MTY2YTRkZmZiNzBhMDBmN2I2YzVlZnx7InJlbW90ZV9hZGRyZXNzIjoiMTAzLjg4LjQ2LjEwOSIsInJlcXVlc3RfaWQiOiJERDFEOjY5ODQ6N0U4MzREOkFBOTJFNDo1RURGNTRFRiIsInRpbWVzdGFtcCI6MTU5MTY5NDU4OCwiaG9zdCI6ImdpdGh1Yi5jb20ifQ==">

    <meta name="enabled-features" content="MARKETPLACE_PENDING_INSTALLATIONS,PAGE_STALE_CHECK,JS_CHUNKING">

  <meta http-equiv="x-pjax-version" content="b62c237c2a6ab551f32581f090807d5b">
  

      <link href="https://github.com/acmesh-official/acme.sh/commits/master.atom" rel="alternate" title="Recent Commits to acme.sh:master" type="application/atom+xml">

  <meta name="go-import" content="github.com/acmesh-official/acme.sh git https://github.com/acmesh-official/acme.sh.git">

  <meta name="octolytics-dimension-user_id" content="60454762" /><meta name="octolytics-dimension-user_login" content="acmesh-official" /><meta name="octolytics-dimension-repository_id" content="48610662" /><meta name="octolytics-dimension-repository_nwo" content="acmesh-official/acme.sh" /><meta name="octolytics-dimension-repository_public" content="true" /><meta name="octolytics-dimension-repository_is_fork" content="false" /><meta name="octolytics-dimension-repository_network_root_id" content="48610662" /><meta name="octolytics-dimension-repository_network_root_nwo" content="acmesh-official/acme.sh" /><meta name="octolytics-dimension-repository_explore_github_marketplace_ci_cta_shown" content="false" />


    <link rel="canonical" href="https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh" data-pjax-transient>


  <meta name="browser-stats-url" content="https://api.github.com/_private/browser/stats">

  <meta name="browser-errors-url" content="https://api.github.com/_private/browser/errors">

  <link rel="mask-icon" href="https://github.githubassets.com/pinned-octocat.svg" color="#000000">
  <link rel="alternate icon" class="js-site-favicon" type="image/png" href="https://github.githubassets.com/favicons/favicon.png">
  <link rel="icon" class="js-site-favicon" type="image/svg+xml" href="https://github.githubassets.com/favicons/favicon.svg">

<meta name="theme-color" content="#1e2327">


  <link rel="manifest" href="/manifest.json" crossOrigin="use-credentials">

  </head>

  <body class="logged-in env-production page-responsive page-blob">
    

    <div class="position-relative js-header-wrapper ">
      <a href="#start-of-content" class="p-3 bg-blue text-white show-on-focus js-skip-to-content">Skip to content</a>
      <span class="Progress progress-pjax-loader position-fixed width-full js-pjax-loader-bar">
        <span class="progress-pjax-loader-bar top-0 left-0" style="width: 0%;"></span>
      </span>

      
      



          <header class="Header py-lg-0 js-details-container Details flex-wrap flex-lg-nowrap p-responsive" role="banner">
  <div class="Header-item d-none d-lg-flex">
    <a class="Header-link" href="https://github.com/" data-hotkey="g d"
  aria-label="Homepage " data-ga-click="Header, go to dashboard, icon:logo">
  <svg class="octicon octicon-mark-github v-align-middle" height="32" viewBox="0 0 16 16" version="1.1" width="32" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8C0 11.54 2.29 14.53 5.47 15.59C5.87 15.66 6.02 15.42 6.02 15.21C6.02 15.02 6.01 14.39 6.01 13.72C4 14.09 3.48 13.23 3.32 12.78C3.23 12.55 2.84 11.84 2.5 11.65C2.22 11.5 1.82 11.13 2.49 11.12C3.12 11.11 3.57 11.7 3.72 11.94C4.44 13.15 5.59 12.81 6.05 12.6C6.12 12.08 6.33 11.73 6.56 11.53C4.78 11.33 2.92 10.64 2.92 7.58C2.92 6.71 3.23 5.99 3.74 5.43C3.66 5.23 3.38 4.41 3.82 3.31C3.82 3.31 4.49 3.1 6.02 4.13C6.66 3.95 7.34 3.86 8.02 3.86C8.7 3.86 9.38 3.95 10.02 4.13C11.55 3.09 12.22 3.31 12.22 3.31C12.66 4.41 12.38 5.23 12.3 5.43C12.81 5.99 13.12 6.7 13.12 7.58C13.12 10.65 11.25 11.33 9.47 11.53C9.76 11.78 10.01 12.26 10.01 13.01C10.01 14.08 10 14.94 10 15.21C10 15.42 10.15 15.67 10.55 15.59C13.71 14.53 16 11.53 16 8C16 3.58 12.42 0 8 0Z"></path></svg>
</a>

  </div>

  <div class="Header-item d-lg-none">
    <button class="Header-link btn-link js-details-target" type="button" aria-label="Toggle navigation" aria-expanded="false">
      <svg height="24" class="octicon octicon-three-bars" viewBox="0 0 16 16" version="1.1" width="24" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1 2.75C1 2.55109 1.07902 2.36032 1.21967 2.21967C1.36032 2.07902 1.55109 2 1.75 2H14.25C14.4489 2 14.6397 2.07902 14.7803 2.21967C14.921 2.36032 15 2.55109 15 2.75C15 2.94891 14.921 3.13968 14.7803 3.28033C14.6397 3.42098 14.4489 3.5 14.25 3.5H1.75C1.55109 3.5 1.36032 3.42098 1.21967 3.28033C1.07902 3.13968 1 2.94891 1 2.75ZM1 7.75C1 7.55109 1.07902 7.36032 1.21967 7.21967C1.36032 7.07902 1.55109 7 1.75 7H14.25C14.4489 7 14.6397 7.07902 14.7803 7.21967C14.921 7.36032 15 7.55109 15 7.75C15 7.94891 14.921 8.13968 14.7803 8.28033C14.6397 8.42098 14.4489 8.5 14.25 8.5H1.75C1.55109 8.5 1.36032 8.42098 1.21967 8.28033C1.07902 8.13968 1 7.94891 1 7.75ZM1.75 12C1.55109 12 1.36032 12.079 1.21967 12.2197C1.07902 12.3603 1 12.5511 1 12.75C1 12.9489 1.07902 13.1397 1.21967 13.2803C1.36032 13.421 1.55109 13.5 1.75 13.5H14.25C14.4489 13.5 14.6397 13.421 14.7803 13.2803C14.921 13.1397 15 12.9489 15 12.75C15 12.5511 14.921 12.3603 14.7803 12.2197C14.6397 12.079 14.4489 12 14.25 12H1.75Z"></path></svg>
    </button>
  </div>

  <div class="Header-item Header-item--full flex-column flex-lg-row width-full flex-order-2 flex-lg-order-none mr-0 mr-lg-3 mt-3 mt-lg-0 Details-content--hidden">
        <div class="header-search header-search-current js-header-search-current flex-self-stretch flex-lg-self-auto mr-0 mr-lg-3 mb-3 mb-lg-0 scoped-search site-scoped-search js-site-search position-relative js-jump-to"
  role="combobox"
  aria-owns="jump-to-results"
  aria-label="Search or jump to"
  aria-haspopup="listbox"
  aria-expanded="false"
>
  <div class="position-relative">
    <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="js-site-search-form" role="search" aria-label="Site" data-scope-type="Repository" data-scope-id="48610662" data-scoped-search-url="/acmesh-official/acme.sh/search" data-unscoped-search-url="/search" action="/acmesh-official/acme.sh/search" accept-charset="UTF-8" method="get">
      <label class="form-control input-sm header-search-wrapper p-0 header-search-wrapper-jump-to position-relative d-flex flex-justify-between flex-items-center js-chromeless-input-container">
        <input type="text"
          class="form-control input-sm header-search-input jump-to-field js-jump-to-field js-site-search-focus js-site-search-field is-clearable"
          data-hotkey="s,/"
          name="q"
          value=""
          placeholder="Search or jump to…"
          data-unscoped-placeholder="Search or jump to…"
          data-scoped-placeholder="Search or jump to…"
          autocapitalize="off"
          aria-autocomplete="list"
          aria-controls="jump-to-results"
          aria-label="Search or jump to…"
          data-jump-to-suggestions-path="/_graphql/GetSuggestedNavigationDestinations"
          spellcheck="false"
          autocomplete="off"
          >
          <input type="hidden" value="AXO13VqRjPPnZaxc1zmpUPpwebavpkCBNmRbJPVjcr21F50IaTuc6t4v5AjC86YWS3byMrsmB2Z5bEoAPxOmTw==" data-csrf="true" class="js-data-jump-to-suggestions-path-csrf" />
          <input type="hidden" class="js-site-search-type-field" name="type" >
            <img src="https://github.githubassets.com/images/search-key-slash.svg" alt="" class="mr-2 header-search-key-slash">

            <div class="Box position-absolute overflow-hidden d-none jump-to-suggestions js-jump-to-suggestions-container">
              
<ul class="d-none js-jump-to-suggestions-template-container">
  

<li class="d-flex flex-justify-start flex-items-center p-0 f5 navigation-item js-navigation-item js-jump-to-suggestion" role="option">
  <a tabindex="-1" class="no-underline d-flex flex-auto flex-items-center jump-to-suggestions-path js-jump-to-suggestion-path js-navigation-open p-2" href="">
    <div class="jump-to-octicon js-jump-to-octicon flex-shrink-0 mr-2 text-center d-none">
      <svg height="16" width="16" class="octicon octicon-repo flex-shrink-0 js-jump-to-octicon-repo d-none" title="Repository" aria-label="Repository" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.5C2 1.83696 2.26339 1.20107 2.73223 0.732233C3.20108 0.263392 3.83696 0 4.5 0L13.25 0C13.4489 0 13.6397 0.0790176 13.7803 0.21967C13.921 0.360322 14 0.551088 14 0.75V13.25C14 13.4489 13.921 13.6397 13.7803 13.7803C13.6397 13.921 13.4489 14 13.25 14H10.75C10.5511 14 10.3603 13.921 10.2197 13.7803C10.079 13.6397 10 13.4489 10 13.25C10 13.0511 10.079 12.8603 10.2197 12.7197C10.3603 12.579 10.5511 12.5 10.75 12.5H12.5V10.5H4.5C4.30308 10.5 4.11056 10.5582 3.94657 10.6672C3.78257 10.7762 3.65442 10.9312 3.57816 11.1128C3.50191 11.2943 3.48096 11.4943 3.51793 11.6878C3.5549 11.8812 3.64816 12.0594 3.786 12.2C3.92524 12.3422 4.0023 12.5338 4.00024 12.7328C3.99818 12.9318 3.91716 13.1218 3.775 13.261C3.63285 13.4002 3.4412 13.4773 3.24222 13.4752C3.04325 13.4732 2.85324 13.3922 2.714 13.25C2.25571 12.7829 1.99929 12.1544 2 11.5V2.5ZM12.5 1.5V9H4.5C4.144 9 3.806 9.074 3.5 9.208V2.5C3.5 2.23478 3.60536 1.98043 3.79289 1.79289C3.98043 1.60536 4.23478 1.5 4.5 1.5H12.5ZM5 12.25V15.5C5 15.5464 5.01293 15.5919 5.03734 15.6314C5.06175 15.6709 5.09667 15.7028 5.1382 15.7236C5.17972 15.7444 5.22621 15.7532 5.27245 15.749C5.31869 15.7448 5.36286 15.7279 5.4 15.7L6.85 14.613C6.89328 14.5805 6.94591 14.563 7 14.563C7.05409 14.563 7.10673 14.5805 7.15 14.613L8.6 15.7C8.63714 15.7279 8.68131 15.7448 8.72755 15.749C8.77379 15.7532 8.82028 15.7444 8.8618 15.7236C8.90333 15.7028 8.93826 15.6709 8.96266 15.6314C8.98707 15.5919 9 15.5464 9 15.5V12.25C9 12.1837 8.97366 12.1201 8.92678 12.0732C8.87989 12.0263 8.81631 12 8.75 12H5.25C5.1837 12 5.12011 12.0263 5.07322 12.0732C5.02634 12.1201 5 12.1837 5 12.25Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-project flex-shrink-0 js-jump-to-octicon-project d-none" title="Project" aria-label="Project" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.75 0C0.783502 0 0 0.783501 0 1.75V14.25C0 15.2165 0.783501 16 1.75 16H14.25C15.2165 16 16 15.2165 16 14.25V1.75C16 0.783502 15.2165 0 14.25 0H1.75ZM1.5 1.75C1.5 1.61193 1.61193 1.5 1.75 1.5H14.25C14.3881 1.5 14.5 1.61193 14.5 1.75V14.25C14.5 14.3881 14.3881 14.5 14.25 14.5H1.75C1.61193 14.5 1.5 14.3881 1.5 14.25V1.75ZM11.75 3C11.3358 3 11 3.33579 11 3.75V11.25C11 11.6642 11.3358 12 11.75 12C12.1642 12 12.5 11.6642 12.5 11.25V3.75C12.5 3.33579 12.1642 3 11.75 3ZM3.5 3.75C3.5 3.33579 3.83579 3 4.25 3C4.66421 3 5 3.33579 5 3.75V9.25C5 9.66421 4.66421 10 4.25 10C3.83579 10 3.5 9.66421 3.5 9.25V3.75ZM8 3C7.58579 3 7.25 3.33579 7.25 3.75V7.25C7.25 7.66421 7.58579 8 8 8C8.41421 8 8.75 7.66421 8.75 7.25V3.75C8.75 3.33579 8.41421 3 8 3Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-search flex-shrink-0 js-jump-to-octicon-search d-none" title="Search" aria-label="Search" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.5 7C11.5 7.59094 11.3836 8.17611 11.1574 8.72207C10.9313 9.26804 10.5998 9.76411 10.182 10.182C9.7641 10.5998 9.26803 10.9313 8.72206 11.1575C8.1761 11.3836 7.59094 11.5 6.99999 11.5C6.40904 11.5 5.82388 11.3836 5.27791 11.1575C4.73195 10.9313 4.23587 10.5998 3.81801 10.182C3.40014 9.76411 3.06868 9.26804 2.84253 8.72207C2.61638 8.17611 2.49999 7.59094 2.49999 7C2.49999 5.80652 2.97409 4.66193 3.81801 3.81802C4.66192 2.9741 5.80651 2.5 6.99999 2.5C8.19346 2.5 9.33805 2.9741 10.182 3.81802C11.0259 4.66193 11.5 5.80652 11.5 7ZM10.68 11.74C9.47437 12.676 7.95736 13.1173 6.43779 12.9741C4.91822 12.831 3.51033 12.1141 2.50074 10.9694C1.49114 9.82471 0.95574 8.33829 1.00352 6.81275C1.05131 5.2872 1.67869 3.8372 2.75794 2.75795C3.8372 1.6787 5.28719 1.05132 6.81274 1.00353C8.33829 0.955747 9.8247 1.49115 10.9694 2.50075C12.1141 3.51034 12.831 4.91823 12.9741 6.4378C13.1173 7.95736 12.676 9.47437 11.74 10.68L14.78 13.72C14.8537 13.7887 14.9128 13.8715 14.9538 13.9635C14.9948 14.0555 15.0168 14.1548 15.0186 14.2555C15.0204 14.3562 15.0018 14.4562 14.9641 14.5496C14.9264 14.643 14.8702 14.7278 14.799 14.799C14.7278 14.8703 14.643 14.9264 14.5496 14.9641C14.4562 15.0018 14.3562 15.0204 14.2555 15.0186C14.1548 15.0168 14.0554 14.9948 13.9635 14.9538C13.8715 14.9128 13.7887 14.8537 13.72 14.78L10.68 11.74Z"></path></svg>
    </div>

    <img class="avatar mr-2 flex-shrink-0 js-jump-to-suggestion-avatar d-none" alt="" aria-label="Team" src="" width="28" height="28">

    <div class="jump-to-suggestion-name js-jump-to-suggestion-name flex-auto overflow-hidden text-left no-wrap css-truncate css-truncate-target">
    </div>

    <div class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none js-jump-to-badge-search">
      <span class="js-jump-to-badge-search-text-default d-none" aria-label="in this repository">
        In this repository
      </span>
      <span class="js-jump-to-badge-search-text-global d-none" aria-label="in all of GitHub">
        All GitHub
      </span>
      <span aria-hidden="true" class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>

    <div aria-hidden="true" class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none d-on-nav-focus js-jump-to-badge-jump">
      Jump to
      <span class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>
  </a>
</li>

</ul>

<ul class="d-none js-jump-to-no-results-template-container">
  <li class="d-flex flex-justify-center flex-items-center f5 d-none js-jump-to-suggestion p-2">
    <span class="text-gray">No suggested jump to results</span>
  </li>
</ul>

<ul id="jump-to-results" role="listbox" class="p-0 m-0 js-navigation-container jump-to-suggestions-results-container js-jump-to-suggestions-results-container">
  

<li class="d-flex flex-justify-start flex-items-center p-0 f5 navigation-item js-navigation-item js-jump-to-scoped-search d-none" role="option">
  <a tabindex="-1" class="no-underline d-flex flex-auto flex-items-center jump-to-suggestions-path js-jump-to-suggestion-path js-navigation-open p-2" href="">
    <div class="jump-to-octicon js-jump-to-octicon flex-shrink-0 mr-2 text-center d-none">
      <svg height="16" width="16" class="octicon octicon-repo flex-shrink-0 js-jump-to-octicon-repo d-none" title="Repository" aria-label="Repository" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.5C2 1.83696 2.26339 1.20107 2.73223 0.732233C3.20108 0.263392 3.83696 0 4.5 0L13.25 0C13.4489 0 13.6397 0.0790176 13.7803 0.21967C13.921 0.360322 14 0.551088 14 0.75V13.25C14 13.4489 13.921 13.6397 13.7803 13.7803C13.6397 13.921 13.4489 14 13.25 14H10.75C10.5511 14 10.3603 13.921 10.2197 13.7803C10.079 13.6397 10 13.4489 10 13.25C10 13.0511 10.079 12.8603 10.2197 12.7197C10.3603 12.579 10.5511 12.5 10.75 12.5H12.5V10.5H4.5C4.30308 10.5 4.11056 10.5582 3.94657 10.6672C3.78257 10.7762 3.65442 10.9312 3.57816 11.1128C3.50191 11.2943 3.48096 11.4943 3.51793 11.6878C3.5549 11.8812 3.64816 12.0594 3.786 12.2C3.92524 12.3422 4.0023 12.5338 4.00024 12.7328C3.99818 12.9318 3.91716 13.1218 3.775 13.261C3.63285 13.4002 3.4412 13.4773 3.24222 13.4752C3.04325 13.4732 2.85324 13.3922 2.714 13.25C2.25571 12.7829 1.99929 12.1544 2 11.5V2.5ZM12.5 1.5V9H4.5C4.144 9 3.806 9.074 3.5 9.208V2.5C3.5 2.23478 3.60536 1.98043 3.79289 1.79289C3.98043 1.60536 4.23478 1.5 4.5 1.5H12.5ZM5 12.25V15.5C5 15.5464 5.01293 15.5919 5.03734 15.6314C5.06175 15.6709 5.09667 15.7028 5.1382 15.7236C5.17972 15.7444 5.22621 15.7532 5.27245 15.749C5.31869 15.7448 5.36286 15.7279 5.4 15.7L6.85 14.613C6.89328 14.5805 6.94591 14.563 7 14.563C7.05409 14.563 7.10673 14.5805 7.15 14.613L8.6 15.7C8.63714 15.7279 8.68131 15.7448 8.72755 15.749C8.77379 15.7532 8.82028 15.7444 8.8618 15.7236C8.90333 15.7028 8.93826 15.6709 8.96266 15.6314C8.98707 15.5919 9 15.5464 9 15.5V12.25C9 12.1837 8.97366 12.1201 8.92678 12.0732C8.87989 12.0263 8.81631 12 8.75 12H5.25C5.1837 12 5.12011 12.0263 5.07322 12.0732C5.02634 12.1201 5 12.1837 5 12.25Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-project flex-shrink-0 js-jump-to-octicon-project d-none" title="Project" aria-label="Project" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.75 0C0.783502 0 0 0.783501 0 1.75V14.25C0 15.2165 0.783501 16 1.75 16H14.25C15.2165 16 16 15.2165 16 14.25V1.75C16 0.783502 15.2165 0 14.25 0H1.75ZM1.5 1.75C1.5 1.61193 1.61193 1.5 1.75 1.5H14.25C14.3881 1.5 14.5 1.61193 14.5 1.75V14.25C14.5 14.3881 14.3881 14.5 14.25 14.5H1.75C1.61193 14.5 1.5 14.3881 1.5 14.25V1.75ZM11.75 3C11.3358 3 11 3.33579 11 3.75V11.25C11 11.6642 11.3358 12 11.75 12C12.1642 12 12.5 11.6642 12.5 11.25V3.75C12.5 3.33579 12.1642 3 11.75 3ZM3.5 3.75C3.5 3.33579 3.83579 3 4.25 3C4.66421 3 5 3.33579 5 3.75V9.25C5 9.66421 4.66421 10 4.25 10C3.83579 10 3.5 9.66421 3.5 9.25V3.75ZM8 3C7.58579 3 7.25 3.33579 7.25 3.75V7.25C7.25 7.66421 7.58579 8 8 8C8.41421 8 8.75 7.66421 8.75 7.25V3.75C8.75 3.33579 8.41421 3 8 3Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-search flex-shrink-0 js-jump-to-octicon-search d-none" title="Search" aria-label="Search" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.5 7C11.5 7.59094 11.3836 8.17611 11.1574 8.72207C10.9313 9.26804 10.5998 9.76411 10.182 10.182C9.7641 10.5998 9.26803 10.9313 8.72206 11.1575C8.1761 11.3836 7.59094 11.5 6.99999 11.5C6.40904 11.5 5.82388 11.3836 5.27791 11.1575C4.73195 10.9313 4.23587 10.5998 3.81801 10.182C3.40014 9.76411 3.06868 9.26804 2.84253 8.72207C2.61638 8.17611 2.49999 7.59094 2.49999 7C2.49999 5.80652 2.97409 4.66193 3.81801 3.81802C4.66192 2.9741 5.80651 2.5 6.99999 2.5C8.19346 2.5 9.33805 2.9741 10.182 3.81802C11.0259 4.66193 11.5 5.80652 11.5 7ZM10.68 11.74C9.47437 12.676 7.95736 13.1173 6.43779 12.9741C4.91822 12.831 3.51033 12.1141 2.50074 10.9694C1.49114 9.82471 0.95574 8.33829 1.00352 6.81275C1.05131 5.2872 1.67869 3.8372 2.75794 2.75795C3.8372 1.6787 5.28719 1.05132 6.81274 1.00353C8.33829 0.955747 9.8247 1.49115 10.9694 2.50075C12.1141 3.51034 12.831 4.91823 12.9741 6.4378C13.1173 7.95736 12.676 9.47437 11.74 10.68L14.78 13.72C14.8537 13.7887 14.9128 13.8715 14.9538 13.9635C14.9948 14.0555 15.0168 14.1548 15.0186 14.2555C15.0204 14.3562 15.0018 14.4562 14.9641 14.5496C14.9264 14.643 14.8702 14.7278 14.799 14.799C14.7278 14.8703 14.643 14.9264 14.5496 14.9641C14.4562 15.0018 14.3562 15.0204 14.2555 15.0186C14.1548 15.0168 14.0554 14.9948 13.9635 14.9538C13.8715 14.9128 13.7887 14.8537 13.72 14.78L10.68 11.74Z"></path></svg>
    </div>

    <img class="avatar mr-2 flex-shrink-0 js-jump-to-suggestion-avatar d-none" alt="" aria-label="Team" src="" width="28" height="28">

    <div class="jump-to-suggestion-name js-jump-to-suggestion-name flex-auto overflow-hidden text-left no-wrap css-truncate css-truncate-target">
    </div>

    <div class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none js-jump-to-badge-search">
      <span class="js-jump-to-badge-search-text-default d-none" aria-label="in this repository">
        In this repository
      </span>
      <span class="js-jump-to-badge-search-text-global d-none" aria-label="in all of GitHub">
        All GitHub
      </span>
      <span aria-hidden="true" class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>

    <div aria-hidden="true" class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none d-on-nav-focus js-jump-to-badge-jump">
      Jump to
      <span class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>
  </a>
</li>

  

<li class="d-flex flex-justify-start flex-items-center p-0 f5 navigation-item js-navigation-item js-jump-to-global-search d-none" role="option">
  <a tabindex="-1" class="no-underline d-flex flex-auto flex-items-center jump-to-suggestions-path js-jump-to-suggestion-path js-navigation-open p-2" href="">
    <div class="jump-to-octicon js-jump-to-octicon flex-shrink-0 mr-2 text-center d-none">
      <svg height="16" width="16" class="octicon octicon-repo flex-shrink-0 js-jump-to-octicon-repo d-none" title="Repository" aria-label="Repository" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.5C2 1.83696 2.26339 1.20107 2.73223 0.732233C3.20108 0.263392 3.83696 0 4.5 0L13.25 0C13.4489 0 13.6397 0.0790176 13.7803 0.21967C13.921 0.360322 14 0.551088 14 0.75V13.25C14 13.4489 13.921 13.6397 13.7803 13.7803C13.6397 13.921 13.4489 14 13.25 14H10.75C10.5511 14 10.3603 13.921 10.2197 13.7803C10.079 13.6397 10 13.4489 10 13.25C10 13.0511 10.079 12.8603 10.2197 12.7197C10.3603 12.579 10.5511 12.5 10.75 12.5H12.5V10.5H4.5C4.30308 10.5 4.11056 10.5582 3.94657 10.6672C3.78257 10.7762 3.65442 10.9312 3.57816 11.1128C3.50191 11.2943 3.48096 11.4943 3.51793 11.6878C3.5549 11.8812 3.64816 12.0594 3.786 12.2C3.92524 12.3422 4.0023 12.5338 4.00024 12.7328C3.99818 12.9318 3.91716 13.1218 3.775 13.261C3.63285 13.4002 3.4412 13.4773 3.24222 13.4752C3.04325 13.4732 2.85324 13.3922 2.714 13.25C2.25571 12.7829 1.99929 12.1544 2 11.5V2.5ZM12.5 1.5V9H4.5C4.144 9 3.806 9.074 3.5 9.208V2.5C3.5 2.23478 3.60536 1.98043 3.79289 1.79289C3.98043 1.60536 4.23478 1.5 4.5 1.5H12.5ZM5 12.25V15.5C5 15.5464 5.01293 15.5919 5.03734 15.6314C5.06175 15.6709 5.09667 15.7028 5.1382 15.7236C5.17972 15.7444 5.22621 15.7532 5.27245 15.749C5.31869 15.7448 5.36286 15.7279 5.4 15.7L6.85 14.613C6.89328 14.5805 6.94591 14.563 7 14.563C7.05409 14.563 7.10673 14.5805 7.15 14.613L8.6 15.7C8.63714 15.7279 8.68131 15.7448 8.72755 15.749C8.77379 15.7532 8.82028 15.7444 8.8618 15.7236C8.90333 15.7028 8.93826 15.6709 8.96266 15.6314C8.98707 15.5919 9 15.5464 9 15.5V12.25C9 12.1837 8.97366 12.1201 8.92678 12.0732C8.87989 12.0263 8.81631 12 8.75 12H5.25C5.1837 12 5.12011 12.0263 5.07322 12.0732C5.02634 12.1201 5 12.1837 5 12.25Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-project flex-shrink-0 js-jump-to-octicon-project d-none" title="Project" aria-label="Project" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.75 0C0.783502 0 0 0.783501 0 1.75V14.25C0 15.2165 0.783501 16 1.75 16H14.25C15.2165 16 16 15.2165 16 14.25V1.75C16 0.783502 15.2165 0 14.25 0H1.75ZM1.5 1.75C1.5 1.61193 1.61193 1.5 1.75 1.5H14.25C14.3881 1.5 14.5 1.61193 14.5 1.75V14.25C14.5 14.3881 14.3881 14.5 14.25 14.5H1.75C1.61193 14.5 1.5 14.3881 1.5 14.25V1.75ZM11.75 3C11.3358 3 11 3.33579 11 3.75V11.25C11 11.6642 11.3358 12 11.75 12C12.1642 12 12.5 11.6642 12.5 11.25V3.75C12.5 3.33579 12.1642 3 11.75 3ZM3.5 3.75C3.5 3.33579 3.83579 3 4.25 3C4.66421 3 5 3.33579 5 3.75V9.25C5 9.66421 4.66421 10 4.25 10C3.83579 10 3.5 9.66421 3.5 9.25V3.75ZM8 3C7.58579 3 7.25 3.33579 7.25 3.75V7.25C7.25 7.66421 7.58579 8 8 8C8.41421 8 8.75 7.66421 8.75 7.25V3.75C8.75 3.33579 8.41421 3 8 3Z"></path></svg>
      <svg height="16" width="16" class="octicon octicon-search flex-shrink-0 js-jump-to-octicon-search d-none" title="Search" aria-label="Search" viewBox="0 0 16 16" version="1.1" role="img"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.5 7C11.5 7.59094 11.3836 8.17611 11.1574 8.72207C10.9313 9.26804 10.5998 9.76411 10.182 10.182C9.7641 10.5998 9.26803 10.9313 8.72206 11.1575C8.1761 11.3836 7.59094 11.5 6.99999 11.5C6.40904 11.5 5.82388 11.3836 5.27791 11.1575C4.73195 10.9313 4.23587 10.5998 3.81801 10.182C3.40014 9.76411 3.06868 9.26804 2.84253 8.72207C2.61638 8.17611 2.49999 7.59094 2.49999 7C2.49999 5.80652 2.97409 4.66193 3.81801 3.81802C4.66192 2.9741 5.80651 2.5 6.99999 2.5C8.19346 2.5 9.33805 2.9741 10.182 3.81802C11.0259 4.66193 11.5 5.80652 11.5 7ZM10.68 11.74C9.47437 12.676 7.95736 13.1173 6.43779 12.9741C4.91822 12.831 3.51033 12.1141 2.50074 10.9694C1.49114 9.82471 0.95574 8.33829 1.00352 6.81275C1.05131 5.2872 1.67869 3.8372 2.75794 2.75795C3.8372 1.6787 5.28719 1.05132 6.81274 1.00353C8.33829 0.955747 9.8247 1.49115 10.9694 2.50075C12.1141 3.51034 12.831 4.91823 12.9741 6.4378C13.1173 7.95736 12.676 9.47437 11.74 10.68L14.78 13.72C14.8537 13.7887 14.9128 13.8715 14.9538 13.9635C14.9948 14.0555 15.0168 14.1548 15.0186 14.2555C15.0204 14.3562 15.0018 14.4562 14.9641 14.5496C14.9264 14.643 14.8702 14.7278 14.799 14.799C14.7278 14.8703 14.643 14.9264 14.5496 14.9641C14.4562 15.0018 14.3562 15.0204 14.2555 15.0186C14.1548 15.0168 14.0554 14.9948 13.9635 14.9538C13.8715 14.9128 13.7887 14.8537 13.72 14.78L10.68 11.74Z"></path></svg>
    </div>

    <img class="avatar mr-2 flex-shrink-0 js-jump-to-suggestion-avatar d-none" alt="" aria-label="Team" src="" width="28" height="28">

    <div class="jump-to-suggestion-name js-jump-to-suggestion-name flex-auto overflow-hidden text-left no-wrap css-truncate css-truncate-target">
    </div>

    <div class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none js-jump-to-badge-search">
      <span class="js-jump-to-badge-search-text-default d-none" aria-label="in this repository">
        In this repository
      </span>
      <span class="js-jump-to-badge-search-text-global d-none" aria-label="in all of GitHub">
        All GitHub
      </span>
      <span aria-hidden="true" class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>

    <div aria-hidden="true" class="border rounded-1 flex-shrink-0 bg-gray px-1 text-gray-light ml-1 f6 d-none d-on-nav-focus js-jump-to-badge-jump">
      Jump to
      <span class="d-inline-block ml-1 v-align-middle">↵</span>
    </div>
  </a>
</li>


    <li class="d-flex flex-justify-center flex-items-center p-0 f5 js-jump-to-suggestion">
      <img src="https://github.githubassets.com/images/spinners/octocat-spinner-128.gif" alt="Octocat Spinner Icon" class="m-2" width="28">
    </li>
</ul>

            </div>
      </label>
</form>  </div>
</div>


    <nav class="d-flex flex-column flex-lg-row flex-self-stretch flex-lg-self-auto" aria-label="Global">
    <a class="Header-link py-lg-3 d-block d-lg-none py-2 border-top border-lg-top-0 border-white-fade-15" data-ga-click="Header, click, Nav menu - item:dashboard:user" aria-label="Dashboard" href="/dashboard">
      Dashboard
</a>
  <a class="js-selected-navigation-item Header-link py-lg-3  mr-0 mr-lg-3 py-2 border-top border-lg-top-0 border-white-fade-15" data-hotkey="g p" data-ga-click="Header, click, Nav menu - item:pulls context:user" aria-label="Pull requests you created" data-selected-links="/pulls /pulls/assigned /pulls/mentioned /pulls" href="/pulls">
    Pull requests
</a>
  <a class="js-selected-navigation-item Header-link py-lg-3  mr-0 mr-lg-3 py-2 border-top border-lg-top-0 border-white-fade-15" data-hotkey="g i" data-ga-click="Header, click, Nav menu - item:issues context:user" aria-label="Issues you created" data-selected-links="/issues /issues/assigned /issues/mentioned /issues" href="/issues">
    Issues
</a>

    <div class="mr-0 mr-lg-3 py-2 py-lg-0 border-top border-lg-top-0 border-white-fade-15">
      <a class="js-selected-navigation-item Header-link py-lg-3 d-inline-block" data-ga-click="Header, click, Nav menu - item:marketplace context:user" data-octo-click="marketplace_click" data-octo-dimensions="location:nav_bar" data-selected-links=" /marketplace" href="/marketplace">
        Marketplace
</a>      

    </div>

  <a class="js-selected-navigation-item Header-link py-lg-3  mr-0 mr-lg-3 py-2 border-top border-lg-top-0 border-white-fade-15" data-ga-click="Header, click, Nav menu - item:explore" data-selected-links="/explore /trending /trending/developers /integrations /integrations/feature/code /integrations/feature/collaborate /integrations/feature/ship showcases showcases_search showcases_landing /explore" href="/explore">
    Explore
</a>


    <a class="Header-link d-block d-lg-none mr-0 mr-lg-3 py-2 py-lg-3 border-top border-lg-top-0 border-white-fade-15" href="/mu-yu">
      <img class="avatar avatar-user" src="https://avatars1.githubusercontent.com/u/3822774?s=40&amp;v=4" width="20" height="20" alt="@mu-yu" />
      mu-yu
</a>
    <!-- '"` --><!-- </textarea></xmp> --></option></form><form action="/logout" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="yxUGqsomkpsxNq52geMBETWzwn47dKb/D9X7rwP7vwPvh0lJlN2iLckqo2VT0s7SQBjFmx2UEX5d5Bt+97HEEw==" />
      <button type="submit" class="Header-link mr-0 mr-lg-3 py-2 py-lg-3 border-top border-lg-top-0 border-white-fade-15 d-lg-none btn-link d-block width-full text-left" data-ga-click="Header, sign out, icon:logout" style="padding-left: 2px;">
        <svg class="octicon octicon-sign-out v-align-middle" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.75C2 1.7835 2.7835 1 3.75 1H6.25C6.66421 1 7 1.33579 7 1.75C7 2.16421 6.66421 2.5 6.25 2.5H3.75C3.61193 2.5 3.5 2.61193 3.5 2.75V13.25C3.5 13.3881 3.61193 13.5 3.75 13.5H6.25C6.66421 13.5 7 13.8358 7 14.25C7 14.6642 6.66421 15 6.25 15H3.75C2.7835 15 2 14.2165 2 13.25V2.75ZM12.4393 7.25L6.75002 7.25C6.33581 7.25 6.00002 7.58579 6.00002 8C6.00002 8.41422 6.33581 8.75 6.75002 8.75L12.4393 8.75L10.4697 10.7197C10.1768 11.0126 10.1768 11.4874 10.4697 11.7803C10.7626 12.0732 11.2374 12.0732 11.5303 11.7803L14.7803 8.53033C15.0732 8.23744 15.0732 7.76256 14.7803 7.46967L11.5303 4.21967C11.2374 3.92678 10.7626 3.92678 10.4697 4.21967C10.1768 4.51256 10.1768 4.98744 10.4697 5.28033L12.4393 7.25Z"></path></svg>
        Sign out
      </button>
</form></nav>

  </div>

  <div class="Header-item Header-item--full flex-justify-center d-lg-none position-relative">
    <div class="css-truncate css-truncate-target width-fit position-absolute left-0 right-0 text-center">
                <svg class="octicon octicon-repo" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.5C2 1.83696 2.26339 1.20107 2.73223 0.732233C3.20108 0.263392 3.83696 0 4.5 0L13.25 0C13.4489 0 13.6397 0.0790176 13.7803 0.21967C13.921 0.360322 14 0.551088 14 0.75V13.25C14 13.4489 13.921 13.6397 13.7803 13.7803C13.6397 13.921 13.4489 14 13.25 14H10.75C10.5511 14 10.3603 13.921 10.2197 13.7803C10.079 13.6397 10 13.4489 10 13.25C10 13.0511 10.079 12.8603 10.2197 12.7197C10.3603 12.579 10.5511 12.5 10.75 12.5H12.5V10.5H4.5C4.30308 10.5 4.11056 10.5582 3.94657 10.6672C3.78257 10.7762 3.65442 10.9312 3.57816 11.1128C3.50191 11.2943 3.48096 11.4943 3.51793 11.6878C3.5549 11.8812 3.64816 12.0594 3.786 12.2C3.92524 12.3422 4.0023 12.5338 4.00024 12.7328C3.99818 12.9318 3.91716 13.1218 3.775 13.261C3.63285 13.4002 3.4412 13.4773 3.24222 13.4752C3.04325 13.4732 2.85324 13.3922 2.714 13.25C2.25571 12.7829 1.99929 12.1544 2 11.5V2.5ZM12.5 1.5V9H4.5C4.144 9 3.806 9.074 3.5 9.208V2.5C3.5 2.23478 3.60536 1.98043 3.79289 1.79289C3.98043 1.60536 4.23478 1.5 4.5 1.5H12.5ZM5 12.25V15.5C5 15.5464 5.01293 15.5919 5.03734 15.6314C5.06175 15.6709 5.09667 15.7028 5.1382 15.7236C5.17972 15.7444 5.22621 15.7532 5.27245 15.749C5.31869 15.7448 5.36286 15.7279 5.4 15.7L6.85 14.613C6.89328 14.5805 6.94591 14.563 7 14.563C7.05409 14.563 7.10673 14.5805 7.15 14.613L8.6 15.7C8.63714 15.7279 8.68131 15.7448 8.72755 15.749C8.77379 15.7532 8.82028 15.7444 8.8618 15.7236C8.90333 15.7028 8.93826 15.6709 8.96266 15.6314C8.98707 15.5919 9 15.5464 9 15.5V12.25C9 12.1837 8.97366 12.1201 8.92678 12.0732C8.87989 12.0263 8.81631 12 8.75 12H5.25C5.1837 12 5.12011 12.0263 5.07322 12.0732C5.02634 12.1201 5 12.1837 5 12.25Z"></path></svg>
    <a class="Header-link" href="/acmesh-official">acmesh-official</a>
    /
    <a class="Header-link" href="/acmesh-official/acme.sh">acme.sh</a>

</div>
  </div>

  <div class="Header-item mr-0 mr-lg-3 flex-order-1 flex-lg-order-none">
    
    <a aria-label="You have unread notifications" class="Header-link notification-indicator position-relative tooltipped tooltipped-sw js-socket-channel js-notification-indicator" data-hotkey="g n" data-ga-click="Header, go to notifications, icon:unread" data-channel="notification-changed:3822774" href="/notifications">
        <span class="js-indicator-modifier mail-status unread"></span>
        <svg class="octicon octicon-bell" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 16C9.02008 16 9.86178 15.2363 9.98459 14.2495C10.0016 14.1125 9.88807 14 9.75 14H6.25C6.11193 14 5.99836 14.1125 6.01541 14.2495C6.13822 15.2363 6.97992 16 8 16Z"></path>
  <path fill-rule="evenodd" clip-rule="evenodd" d="M8 1.5C6.067 1.5 4.5 3.067 4.5 5V7.94722C4.5 8.29272 4.39773 8.63048 4.20609 8.91795L2.50295 11.4726C2.50103 11.4755 2.5 11.4789 2.5 11.4824C2.5 11.4862 2.50063 11.488 2.50107 11.489C2.50174 11.4906 2.50302 11.4927 2.50515 11.4948C2.50729 11.497 2.50941 11.4983 2.51097 11.4989C2.51204 11.4994 2.51378 11.5 2.51759 11.5H13.4824C13.4862 11.5 13.488 11.4994 13.489 11.4989C13.4906 11.4983 13.4927 11.497 13.4948 11.4948C13.497 11.4927 13.4983 11.4906 13.4989 11.489C13.4994 11.488 13.5 11.4862 13.5 11.4824C13.5 11.4789 13.499 11.4755 13.497 11.4726L11.7939 8.91795C11.6023 8.63048 11.5 8.29272 11.5 7.94722V5C11.5 3.067 9.933 1.5 8 1.5ZM3 5C3 2.23858 5.23858 0 8 0C10.7614 0 13 2.23858 13 5V7.94722C13 7.99658 13.0146 8.04483 13.042 8.0859L14.7451 10.6406C14.9113 10.8899 15 11.1828 15 11.4824C15 12.3206 14.3206 13 13.4824 13H2.51759C1.67945 13 1 12.3206 1 11.4824C1 11.1828 1.08868 10.8899 1.25488 10.6406L2.95801 8.0859C2.98539 8.04483 3 7.99658 3 7.94722V5Z"></path></svg>
</a>
  </div>


  <div class="Header-item position-relative d-none d-lg-flex">
    <details class="details-overlay details-reset">
  <summary class="Header-link"
      aria-label="Create new…"
      data-ga-click="Header, create new, icon:add">
    <svg class="octicon octicon-plus" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 2C8.41421 2 8.75 2.33579 8.75 2.75V7.25H13.25C13.6642 7.25 14 7.58579 14 8C14 8.41421 13.6642 8.75 13.25 8.75H8.75V13.25C8.75 13.6642 8.41421 14 8 14C7.58579 14 7.25 13.6642 7.25 13.25V8.75H2.75C2.33579 8.75 2 8.41421 2 8C2 7.58579 2.33579 7.25 2.75 7.25H7.25V2.75C7.25 2.33579 7.58579 2 8 2Z"></path></svg> <span class="dropdown-caret"></span>
  </summary>
  <details-menu class="dropdown-menu dropdown-menu-sw mt-n2">
    
<a role="menuitem" class="dropdown-item" href="/new" data-ga-click="Header, create new repository">
  New repository
</a>

  <a role="menuitem" class="dropdown-item" href="/new/import" data-ga-click="Header, import a repository">
    Import repository
  </a>

<a role="menuitem" class="dropdown-item" href="https://gist.github.com/" data-ga-click="Header, create new gist">
  New gist
</a>

  <a role="menuitem" class="dropdown-item" href="/organizations/new" data-ga-click="Header, create new organization">
    New organization
  </a>


  <div role="none" class="dropdown-divider"></div>
  <div class="dropdown-header">
    <span title="acmesh-official/acme.sh">This repository</span>
  </div>
    <a role="menuitem" class="dropdown-item" href="/acmesh-official/acme.sh/issues/new/choose" data-ga-click="Header, create new issue" data-skip-pjax>
      New issue
    </a>


  </details-menu>
</details>

  </div>

  <div class="Header-item position-relative mr-0 d-none d-lg-flex">
    
  <details class="details-overlay details-reset js-feature-preview-indicator-container" data-feature-preview-indicator-src="/users/mu-yu/feature_preview/indicator_check">

  <summary class="Header-link"
    aria-label="View profile and more"
    data-ga-click="Header, show menu, icon:avatar">
    <img
  alt="@mu-yu"
  width="20"
  height="20"
  src="https://avatars2.githubusercontent.com/u/3822774?s=60&amp;v=4"
  class="avatar avatar-user " />

      <span class="feature-preview-indicator js-feature-preview-indicator" style="top: 10px;" hidden></span>
    <span class="dropdown-caret"></span>
  </summary>
  <details-menu class="dropdown-menu dropdown-menu-sw mt-n2" style="width: 180px">
    <div class="header-nav-current-user css-truncate"><a role="menuitem" class="no-underline user-profile-link px-3 pt-2 pb-2 mb-n2 mt-n1 d-block" href="/mu-yu" data-ga-click="Header, go to profile, text:Signed in as">Signed in as <strong class="css-truncate-target">mu-yu</strong></a></div>
    <div role="none" class="dropdown-divider"></div>

      <div class="pl-3 pr-3 f6 user-status-container js-user-status-context pb-1" data-url="/users/status?compact=1&amp;link_mentions=0&amp;truncate=1">
        
<div class="js-user-status-container
    user-status-compact rounded-1 px-2 py-1 mt-2
    border
  " data-team-hovercards-enabled>
  <details class="js-user-status-details details-reset details-overlay details-overlay-dark">
    <summary class="btn-link btn-block link-gray no-underline js-toggle-user-status-edit toggle-user-status-edit "
      role="menuitem" data-hydro-click="{&quot;event_type&quot;:&quot;user_profile.click&quot;,&quot;payload&quot;:{&quot;profile_user_id&quot;:60454762,&quot;target&quot;:&quot;EDIT_USER_STATUS&quot;,&quot;user_id&quot;:3822774,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;}}" data-hydro-click-hmac="f9bdbb216cf8c531ef61285a116490a9412b02469e05bdeffa841f793925282e">
      <div class="d-flex">
        <div class="f6 lh-condensed user-status-header
          d-inline-block v-align-middle
            user-status-emoji-only-header circle
            pr-2
"
            style="max-width: 29px"
          >
          <div class="user-status-emoji-container flex-shrink-0 mr-1  lh-condensed-ultra v-align-bottom" style="margin-top: 2px;">
            <div><g-emoji class="g-emoji" alias="dart" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f3af.png">🎯</g-emoji></div>
          </div>
        </div>
        <div class="
          d-inline-block v-align-middle
          
          
           css-truncate css-truncate-target 
           user-status-message-wrapper f6"
           style="line-height: 20px;" >
          <div class="d-inline-block text-gray-dark v-align-text-top text-left">
                <span>Focusing</span>
          </div>
        </div>
      </div>
    </summary>
    <details-dialog class="details-dialog rounded-1 anim-fade-in fast Box Box--overlay" role="dialog" tabindex="-1">
      <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="position-relative flex-auto js-user-status-form" action="/users/status?compact=1&amp;link_mentions=0&amp;truncate=1" accept-charset="UTF-8" method="post"><input type="hidden" name="_method" value="put" /><input type="hidden" name="authenticity_token" value="OHgJs8QQHOvqRzG52BvuiPp3TqMm7yYElkeK0Jf3Sgw5f6L9Y6pe7t8YdDpUixpA0w5WtB9cOrUCwpNYEBYBEQ==" />
        <div class="Box-header bg-gray border-bottom p-3">
          <button class="Box-btn-octicon js-toggle-user-status-edit btn-octicon float-right" type="reset" aria-label="Close dialog" data-close-dialog>
            <svg class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>
          </button>
          <h3 class="Box-title f5 text-bold text-gray-dark">Edit status</h3>
        </div>
        <input type="hidden" name="emoji" class="js-user-status-emoji-field" value=":dart:">
        <input type="hidden" name="organization_id" class="js-user-status-org-id-field" value="">
        <div class="px-3 py-2 text-gray-dark">
          <div class="js-characters-remaining-container position-relative mt-2">
            <div class="input-group d-table form-group my-0 js-user-status-form-group">
              <span class="input-group-button d-table-cell v-align-middle" style="width: 1%">
                <button type="button" aria-label="Choose an emoji" class="btn-outline btn js-toggle-user-status-emoji-picker btn-open-emoji-picker p-0">
                  <span class="js-user-status-original-emoji" hidden><div><g-emoji class="g-emoji" alias="dart" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f3af.png">🎯</g-emoji></div></span>
                  <span class="js-user-status-custom-emoji"><div><g-emoji class="g-emoji" alias="dart" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f3af.png">🎯</g-emoji></div></span>
                  <span class="js-user-status-no-emoji-icon" hidden>
                    <svg class="octicon octicon-smiley" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.5 8C1.5 6.27609 2.18482 4.62279 3.40381 3.40381C4.62279 2.18482 6.27609 1.5 8 1.5C9.72391 1.5 11.3772 2.18482 12.5962 3.40381C13.8152 4.62279 14.5 6.27609 14.5 8C14.5 9.72391 13.8152 11.3772 12.5962 12.5962C11.3772 13.8152 9.72391 14.5 8 14.5C6.27609 14.5 4.62279 13.8152 3.40381 12.5962C2.18482 11.3772 1.5 9.72391 1.5 8ZM8 0C5.87827 0 3.84344 0.842855 2.34315 2.34315C0.842855 3.84344 0 5.87827 0 8C0 10.1217 0.842855 12.1566 2.34315 13.6569C3.84344 15.1571 5.87827 16 8 16C10.1217 16 12.1566 15.1571 13.6569 13.6569C15.1571 12.1566 16 10.1217 16 8C16 5.87827 15.1571 3.84344 13.6569 2.34315C12.1566 0.842855 10.1217 0 8 0V0ZM5 8C5.26522 8 5.51957 7.89464 5.70711 7.70711C5.89464 7.51957 6 7.26522 6 7C6 6.73478 5.89464 6.48043 5.70711 6.29289C5.51957 6.10536 5.26522 6 5 6C4.73478 6 4.48043 6.10536 4.29289 6.29289C4.10536 6.48043 4 6.73478 4 7C4 7.26522 4.10536 7.51957 4.29289 7.70711C4.48043 7.89464 4.73478 8 5 8ZM12 7C12 7.26522 11.8946 7.51957 11.7071 7.70711C11.5196 7.89464 11.2652 8 11 8C10.7348 8 10.4804 7.89464 10.2929 7.70711C10.1054 7.51957 10 7.26522 10 7C10 6.73478 10.1054 6.48043 10.2929 6.29289C10.4804 6.10536 10.7348 6 11 6C11.2652 6 11.5196 6.10536 11.7071 6.29289C11.8946 6.48043 12 6.73478 12 7ZM5.32 9.636C5.48134 9.52303 5.68064 9.47806 5.87486 9.51081C6.06908 9.54355 6.24262 9.65138 6.358 9.811L6.365 9.82C6.46785 9.93795 6.58549 10.0421 6.715 10.13C6.979 10.308 7.398 10.5 8 10.5C8.602 10.5 9.02 10.308 9.285 10.129C9.41451 10.0411 9.53215 9.93695 9.635 9.819L9.642 9.811C9.75737 9.64895 9.93239 9.53937 10.1285 9.50637C10.3247 9.47336 10.526 9.51963 10.688 9.635C10.85 9.75037 10.9596 9.92539 10.9926 10.1215C11.0256 10.3177 10.9794 10.519 10.864 10.681L10.25 10.25C10.864 10.68 10.864 10.681 10.863 10.681V10.682L10.862 10.684L10.86 10.687L10.855 10.694L10.841 10.713C10.7848 10.7883 10.7233 10.8594 10.657 10.926C10.4963 11.0924 10.3187 11.2415 10.127 11.371C9.49722 11.7894 8.75607 12.0086 8 12C7.054 12 6.348 11.692 5.874 11.37C5.62319 11.2003 5.39676 10.9971 5.201 10.766C5.1867 10.7486 5.1727 10.7309 5.159 10.713L5.145 10.693L5.14 10.687L5.138 10.684V10.682H5.137L5.75 10.25L5.136 10.68C5.02196 10.5172 4.97718 10.3159 5.01149 10.1201C5.04581 9.92439 5.1564 9.75027 5.319 9.636H5.32Z"></path></svg>
                  </span>
                </button>
              </span>
              <text-expander keys=": @" data-mention-url="/autocomplete/user-suggestions" data-emoji-url="/autocomplete/emoji">
                <input
                  type="text"
                  autocomplete="off"
                  data-no-org-url="/autocomplete/user-suggestions"
                  data-org-url="/suggestions?mention_suggester=1"
                  data-maxlength="80"
                  class="d-table-cell width-full form-control js-user-status-message-field js-characters-remaining-field"
                  placeholder="What's happening?"
                  name="message"
                  value="Focusing"
                  aria-label="What is your current status?">
              </text-expander>
              <div class="error">Could not update your status, please try again.</div>
            </div>
            <div style="margin-left: 53px" class="my-1 text-small label-characters-remaining js-characters-remaining" data-suffix="remaining" hidden>
              80 remaining
            </div>
          </div>
          <include-fragment class="js-user-status-emoji-picker" data-url="/users/status/emoji"></include-fragment>
          <div class="overflow-auto ml-n3 mr-n3 px-3 border-bottom" style="max-height: 33vh">
            <div class="user-status-suggestions js-user-status-suggestions collapsed overflow-hidden">
              <h4 class="f6 text-normal my-3">Suggestions:</h4>
              <div class="mx-3 mt-2 clearfix">
                  <div class="float-left col-6">
                      <button type="button" value=":palm_tree:" class="d-flex flex-items-baseline flex-items-stretch lh-condensed f6 btn-link link-gray no-underline js-predefined-user-status mb-1">
                        <div class="emoji-status-width mr-2 v-align-middle js-predefined-user-status-emoji">
                          <g-emoji alias="palm_tree" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f334.png">🌴</g-emoji>
                        </div>
                        <div class="d-flex flex-items-center no-underline js-predefined-user-status-message ws-normal text-left" style="border-left: 1px solid transparent">
                          On vacation
                        </div>
                      </button>
                      <button type="button" value=":face_with_thermometer:" class="d-flex flex-items-baseline flex-items-stretch lh-condensed f6 btn-link link-gray no-underline js-predefined-user-status mb-1">
                        <div class="emoji-status-width mr-2 v-align-middle js-predefined-user-status-emoji">
                          <g-emoji alias="face_with_thermometer" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f912.png">🤒</g-emoji>
                        </div>
                        <div class="d-flex flex-items-center no-underline js-predefined-user-status-message ws-normal text-left" style="border-left: 1px solid transparent">
                          Out sick
                        </div>
                      </button>
                  </div>
                  <div class="float-left col-6">
                      <button type="button" value=":house:" class="d-flex flex-items-baseline flex-items-stretch lh-condensed f6 btn-link link-gray no-underline js-predefined-user-status mb-1">
                        <div class="emoji-status-width mr-2 v-align-middle js-predefined-user-status-emoji">
                          <g-emoji alias="house" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f3e0.png">🏠</g-emoji>
                        </div>
                        <div class="d-flex flex-items-center no-underline js-predefined-user-status-message ws-normal text-left" style="border-left: 1px solid transparent">
                          Working from home
                        </div>
                      </button>
                      <button type="button" value=":dart:" class="d-flex flex-items-baseline flex-items-stretch lh-condensed f6 btn-link link-gray no-underline js-predefined-user-status mb-1">
                        <div class="emoji-status-width mr-2 v-align-middle js-predefined-user-status-emoji">
                          <g-emoji alias="dart" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f3af.png">🎯</g-emoji>
                        </div>
                        <div class="d-flex flex-items-center no-underline js-predefined-user-status-message ws-normal text-left" style="border-left: 1px solid transparent">
                          Focusing
                        </div>
                      </button>
                  </div>
              </div>
            </div>
            <div class="user-status-limited-availability-container">
              <div class="form-checkbox my-0">
                <input type="checkbox" name="limited_availability" value="1" class="js-user-status-limited-availability-checkbox" data-default-message="I may be slow to respond." aria-describedby="limited-availability-help-text-truncate-true-compact-true" id="limited-availability-truncate-true-compact-true">
                <label class="d-block f5 text-gray-dark mb-1" for="limited-availability-truncate-true-compact-true">
                  Busy
                </label>
                <p class="note" id="limited-availability-help-text-truncate-true-compact-true">
                  When others mention you, assign you, or request your review,
                  GitHub will let them know that you have limited availability.
                </p>
              </div>
            </div>
          </div>
          <div class="d-inline-block f5 mr-2 pt-3 pb-2" >
  <div class="d-inline-block mr-1">
    Clear status
  </div>

  <details class="js-user-status-expire-drop-down f6 dropdown details-reset details-overlay d-inline-block mr-2">
    <summary class="f5 btn-link link-gray-dark border px-2 py-1 rounded-1" aria-haspopup="true">
      <div class="js-user-status-expiration-interval-selected d-inline-block v-align-baseline">
        Never
      </div>
      <div class="dropdown-caret"></div>
    </summary>

    <ul class="dropdown-menu dropdown-menu-se pl-0 overflow-auto" style="width: 220px; max-height: 15.5em">
      <li>
        <button type="button" class="btn-link dropdown-item js-user-status-expire-button ws-normal" title="Never">
          <span class="d-inline-block text-bold mb-1">Never</span>
          <div class="f6 lh-condensed">Keep this status until you clear your status or edit your status.</div>
        </button>
      </li>
      <li class="dropdown-divider" role="none"></li>
        <li>
          <button type="button" class="btn-link dropdown-item ws-normal js-user-status-expire-button" title="in 30 minutes" value="2020-06-09T17:53:08+08:00">
            in 30 minutes
          </button>
        </li>
        <li>
          <button type="button" class="btn-link dropdown-item ws-normal js-user-status-expire-button" title="in 1 hour" value="2020-06-09T18:23:08+08:00">
            in 1 hour
          </button>
        </li>
        <li>
          <button type="button" class="btn-link dropdown-item ws-normal js-user-status-expire-button" title="in 4 hours" value="2020-06-09T21:23:08+08:00">
            in 4 hours
          </button>
        </li>
        <li>
          <button type="button" class="btn-link dropdown-item ws-normal js-user-status-expire-button" title="today" value="2020-06-09T23:59:59+08:00">
            today
          </button>
        </li>
        <li>
          <button type="button" class="btn-link dropdown-item ws-normal js-user-status-expire-button" title="this week" value="2020-06-14T23:59:59+08:00">
            this week
          </button>
        </li>
    </ul>
  </details>
  <input class="js-user-status-expiration-date-input" type="hidden" name="expires_at" value="">
</div>

          <include-fragment class="js-user-status-org-picker" data-url="/users/status/organizations"></include-fragment>
        </div>
        <div class="d-flex flex-items-center flex-justify-between p-3 border-top">
          <button type="submit"  class="width-full btn btn-primary mr-2 js-user-status-submit">
            Set status
          </button>
          <button type="button"  class="width-full js-clear-user-status-button btn ml-2 js-user-status-exists">
            Clear status
          </button>
        </div>
</form>    </details-dialog>
  </details>
</div>

      </div>
      <div role="none" class="dropdown-divider"></div>

    <a role="menuitem" class="dropdown-item" href="/mu-yu" data-ga-click="Header, go to profile, text:your profile">Your profile</a>

    <a role="menuitem" class="dropdown-item" href="/mu-yu?tab=repositories" data-ga-click="Header, go to repositories, text:your repositories">Your repositories</a>

      <a role="menuitem"
         class="dropdown-item"
         href="/settings/organizations?source=your-organizations"
         
         data-ga-click="Header, go to organizations, text:your organizations">Your organizations</a>

    <a role="menuitem" class="dropdown-item" href="/mu-yu?tab=projects" data-ga-click="Header, go to projects, text:your projects">Your projects</a>

    <a role="menuitem" class="dropdown-item" href="/mu-yu?tab=stars" data-ga-click="Header, go to starred repos, text:your stars">Your stars</a>
      <a role="menuitem" class="dropdown-item" href="https://gist.github.com/mine" data-ga-click="Header, your gists, text:your gists">Your gists</a>





    <div role="none" class="dropdown-divider"></div>
      
<div id="feature-enrollment-toggle" class="hide-sm hide-md feature-preview-details position-relative">
  <button
    type="button"
    class="dropdown-item btn-link"
    role="menuitem"
    data-feature-preview-trigger-url="/users/mu-yu/feature_previews"
    data-feature-preview-close-details="{&quot;event_type&quot;:&quot;feature_preview.clicks.close_modal&quot;,&quot;payload&quot;:{&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}"
    data-feature-preview-close-hmac="65710ddf726bae30992746ad6d59497052163f95493abab845e2e8c6256d37e7"
    data-hydro-click="{&quot;event_type&quot;:&quot;feature_preview.clicks.open_modal&quot;,&quot;payload&quot;:{&quot;link_location&quot;:&quot;user_dropdown&quot;,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}"
    data-hydro-click-hmac="5bd8b3b4382c5a5cc2ac4aef2437ce5804c7f8f8d150db5822b0ea045fa79621"
  >
    Feature preview
  </button>
    <span class="feature-preview-indicator js-feature-preview-indicator" hidden></span>
</div>

    <a role="menuitem" class="dropdown-item" href="https://help.github.com" data-ga-click="Header, go to help, text:help">Help</a>
    <a role="menuitem" class="dropdown-item" href="/settings/profile" data-ga-click="Header, go to settings, icon:settings">Settings</a>
    <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="logout-form" action="/logout" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="kwhDJm+bySvydlHyp3ckUlSP2g3SOnYJoNS4AkIf2lG3mgzFMWD5nQpqXOF1RuuRISTd6PTawYjy5VjTtlWhQQ==" />
      
      <button type="submit" class="dropdown-item dropdown-signout" data-ga-click="Header, sign out, icon:logout" role="menuitem">
        Sign out
      </button>
      <input type="text" name="required_field_3022" hidden="hidden" class="form-control" /><input type="hidden" name="timestamp" value="1591694588299" class="form-control" /><input type="hidden" name="timestamp_secret" value="b38dae2c331768aa8c84a8a1420c72a89cedce67117422cd07077e9a3ea45f96" class="form-control" />
</form>  </details-menu>
</details>

  </div>

</header>

        

    </div>

  <div id="start-of-content" class="show-on-focus"></div>




    <div id="js-flash-container">


  <template class="js-flash-template">
    <div class="flash flash-full  js-flash-template-container">
  <div class="container-lg px-2" >
    <button class="flash-close js-flash-close" type="button" aria-label="Dismiss this message">
      <svg class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>
    </button>
    
      <div class="js-flash-template-message"></div>

  </div>
</div>
  </template>
</div>


      

  <include-fragment class="js-notification-shelf-include-fragment" data-base-src="https://github.com/notifications/beta/shelf"></include-fragment>




  <div class="application-main " data-commit-hovercards-enabled>
        <div itemscope itemtype="http://schema.org/SoftwareSourceCode" class="">
    <main  >
      

  




  










  <div class="pagehead repohead hx_repohead readability-menu bg-gray-light pb-0 pt-0 pt-lg-3">

    <div class="d-flex container-lg mb-4 p-responsive d-none d-lg-flex">

      <div class="flex-auto min-width-0 width-fit mr-3">
        <h1 class="public  d-flex flex-wrap flex-items-center break-word float-none ">
  <span class="flex-self-stretch" style="margin-top: -2px;">
      <svg class="octicon octicon-repo" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M2 2.5C2 1.83696 2.26339 1.20107 2.73223 0.732233C3.20108 0.263392 3.83696 0 4.5 0L13.25 0C13.4489 0 13.6397 0.0790176 13.7803 0.21967C13.921 0.360322 14 0.551088 14 0.75V13.25C14 13.4489 13.921 13.6397 13.7803 13.7803C13.6397 13.921 13.4489 14 13.25 14H10.75C10.5511 14 10.3603 13.921 10.2197 13.7803C10.079 13.6397 10 13.4489 10 13.25C10 13.0511 10.079 12.8603 10.2197 12.7197C10.3603 12.579 10.5511 12.5 10.75 12.5H12.5V10.5H4.5C4.30308 10.5 4.11056 10.5582 3.94657 10.6672C3.78257 10.7762 3.65442 10.9312 3.57816 11.1128C3.50191 11.2943 3.48096 11.4943 3.51793 11.6878C3.5549 11.8812 3.64816 12.0594 3.786 12.2C3.92524 12.3422 4.0023 12.5338 4.00024 12.7328C3.99818 12.9318 3.91716 13.1218 3.775 13.261C3.63285 13.4002 3.4412 13.4773 3.24222 13.4752C3.04325 13.4732 2.85324 13.3922 2.714 13.25C2.25571 12.7829 1.99929 12.1544 2 11.5V2.5ZM12.5 1.5V9H4.5C4.144 9 3.806 9.074 3.5 9.208V2.5C3.5 2.23478 3.60536 1.98043 3.79289 1.79289C3.98043 1.60536 4.23478 1.5 4.5 1.5H12.5ZM5 12.25V15.5C5 15.5464 5.01293 15.5919 5.03734 15.6314C5.06175 15.6709 5.09667 15.7028 5.1382 15.7236C5.17972 15.7444 5.22621 15.7532 5.27245 15.749C5.31869 15.7448 5.36286 15.7279 5.4 15.7L6.85 14.613C6.89328 14.5805 6.94591 14.563 7 14.563C7.05409 14.563 7.10673 14.5805 7.15 14.613L8.6 15.7C8.63714 15.7279 8.68131 15.7448 8.72755 15.749C8.77379 15.7532 8.82028 15.7444 8.8618 15.7236C8.90333 15.7028 8.93826 15.6709 8.96266 15.6314C8.98707 15.5919 9 15.5464 9 15.5V12.25C9 12.1837 8.97366 12.1201 8.92678 12.0732C8.87989 12.0263 8.81631 12 8.75 12H5.25C5.1837 12 5.12011 12.0263 5.07322 12.0732C5.02634 12.1201 5 12.1837 5 12.25Z"></path></svg>
  </span>
  <span class="author ml-2 flex-self-stretch" itemprop="author">
    <a class="url fn" rel="author" data-hovercard-type="organization" data-hovercard-url="/orgs/acmesh-official/hovercard" href="/acmesh-official">acmesh-official</a>
  </span>
  <span class="path-divider flex-self-stretch">/</span>
  <strong itemprop="name" class="mr-2 flex-self-stretch">
    <a data-pjax="#js-repo-pjax-container" href="/acmesh-official/acme.sh">acme.sh</a>
  </strong>
  
</h1>


      </div>

      <ul class="pagehead-actions flex-shrink-0 " >

    <li>
      <details id="funding-links-modal" class="details-reset details-overlay details-overlay-dark d-inline-block float-left" >
        <summary id="sponsor-button-repo" class="btn btn-sm"
          title="Sponsor acmesh-official/acme.sh"
          data-ga-click="Repository, show sponsor modal, action:blob#show; text:Sponsor"
          >
          <svg class="octicon octicon-heart text-pink" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.25 2.5C2.91421 2.5 1.5 3.66421 1.5 5.5C1.5 7.64969 3.08041 9.64375 4.8647 11.1819C5.73533 11.9325 6.60962 12.5358 7.26796 12.952C7.56407 13.1392 7.81492 13.2875 8 13.3934C8.18508 13.2875 8.43593 13.1392 8.73204 12.952C9.39039 12.5358 10.2647 11.9325 11.1353 11.1819C12.9196 9.64375 14.5 7.64969 14.5 5.5C14.5 3.66421 13.0858 2.5 11.75 2.5C10.3768 2.5 9.14121 3.48581 8.72114 4.95604C8.62915 5.27802 8.33486 5.5 8 5.5C7.66514 5.5 7.37085 5.27802 7.27886 4.95604C6.85879 3.48581 5.62319 2.5 4.25 2.5ZM8 14.25C7.65543 14.9162 7.65523 14.9161 7.655 14.9159L7.65269 14.9147L7.64731 14.9119L7.62883 14.9022C7.61313 14.8939 7.59074 14.882 7.5621 14.8665C7.50484 14.8356 7.42254 14.7904 7.3188 14.7317C7.1114 14.6142 6.81771 14.442 6.46642 14.2199C5.76538 13.7767 4.82717 13.13 3.8853 12.3181C2.04459 10.7312 0 8.35031 0 5.5C0 2.83579 2.08579 1 4.25 1C5.79736 1 7.15289 1.80151 8 3.01995C8.84711 1.80151 10.2026 1 11.75 1C13.9142 1 16 2.83579 16 5.5C16 8.35031 13.9554 10.7312 12.1147 12.3181C11.1728 13.13 10.2346 13.7767 9.53358 14.2199C9.18229 14.442 8.8886 14.6142 8.6812 14.7317C8.57746 14.7904 8.49517 14.8356 8.4379 14.8665C8.40926 14.882 8.38687 14.8939 8.37117 14.9022L8.35269 14.9119L8.34731 14.9147L8.34501 14.9159C8.34477 14.9161 8.34457 14.9162 8 14.25ZM8 14.25L8.34501 14.9159C8.12889 15.0277 7.87111 15.0277 7.655 14.9159L8 14.25Z"></path></svg>
          Sponsor
        </summary>
        <details-dialog
          class="anim-fade-in fast Box Box--overlay d-flex flex-column"
            src="/acmesh-official/acme.sh/funding_links?fragment=1"
            preload
          >
          <div class="Box-header">
            <button class="Box-btn-octicon btn-octicon float-right" type="button" aria-label="Close dialog" data-close-dialog>
              <svg class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>
            </button>
            <h3 class="Box-title">
              Sponsor acmesh-official/acme.sh
            </h3>
          </div>
          <div class="overflow-auto">
            <include-fragment
              >
              <div class="octocat-spinner my-3" aria-label="Loading..."></div>
            </include-fragment>
          </div>
        </details-dialog>
      </details>
    </li>



  <li>
    

    <!-- '"` --><!-- </textarea></xmp> --></option></form><form data-remote="true" class="js-social-form js-social-container clearfix" action="/notifications/subscribe" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="JQ8nUb7uwvyQL+OPJ1WBEPFhbV34ExStgIIsYUYREDxiqZs2bzgZLEQoBtqwMrqanYHYA4wF4SrUWbaoAvObhQ==" />      <input type="hidden" name="repository_id" value="48610662">

      <details class="details-reset details-overlay select-menu float-left" >
        <summary class="select-menu-button float-left btn btn-sm btn-with-count" data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;WATCH_BUTTON&quot;,&quot;repository_id&quot;:48610662,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}" data-hydro-click-hmac="4a1c89abea5134209bd98cb4cf7c160decfff4049feb09c5c59f40ab16644105" data-ga-click="Repository, click Watch settings, action:blob#show">          <span data-menu-button>
              <svg class="octicon octicon-eye" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.67884 7.93165C2.09143 7.31094 2.9206 6.18152 4.0447 5.21477C5.17567 4.2421 6.52738 3.5 8.00001 3.5C9.47264 3.5 10.8244 4.2421 11.9553 5.21477C13.0794 6.18152 13.9086 7.31094 14.3212 7.93165C14.35 7.975 14.35 8.025 14.3212 8.06835C13.9086 8.68906 13.0794 9.81848 11.9553 10.7852C10.8244 11.7579 9.47264 12.5 8.00001 12.5C6.52738 12.5 5.17567 11.7579 4.0447 10.7852C2.9206 9.81848 2.09143 8.68906 1.67884 8.06835C1.65002 8.025 1.65002 7.975 1.67884 7.93165ZM8.00001 2C6.01865 2 4.32919 2.99167 3.06662 4.07751C1.79718 5.16926 0.880454 6.42307 0.429635 7.10129C0.0664231 7.64771 0.0664245 8.35229 0.429635 8.89871C0.880455 9.57693 1.79718 10.8307 3.06662 11.9225C4.32919 13.0083 6.01865 14 8.00001 14C9.98137 14 11.6708 13.0083 12.9334 11.9225C14.2028 10.8307 15.1196 9.57693 15.5704 8.89871C15.9336 8.35229 15.9336 7.64771 15.5704 7.10129C15.1196 6.42307 14.2028 5.16926 12.9334 4.07751C11.6708 2.99167 9.98137 2 8.00001 2ZM8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z"></path></svg>
              Watch
          </span>
</summary>        <details-menu
          class="select-menu-modal position-absolute mt-5 "
          style="z-index: 99;">
          <div class="select-menu-header">
            <span class="select-menu-title">Notifications</span>
          </div>
          <div class="select-menu-list">
            <button
              type="submit"
              name="do"
              value="included"
              class="select-menu-item width-full"
              aria-checked="true"
              role="menuitemradio"
              
            >
              <svg class="octicon octicon-check select-menu-item-icon" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M13.78 4.22C13.9204 4.36062 13.9993 4.55125 13.9993 4.75C13.9993 4.94875 13.9204 5.13937 13.78 5.28L6.53 12.53C6.38937 12.6704 6.19875 12.7493 6 12.7493C5.80125 12.7493 5.61062 12.6704 5.47 12.53L2.22 9.28C2.08752 9.13782 2.0154 8.94978 2.01882 8.75547C2.02225 8.56117 2.10096 8.37579 2.23838 8.23837C2.37579 8.10096 2.56118 8.02225 2.75548 8.01882C2.94978 8.01539 3.13782 8.08752 3.28 8.22L6 10.94L12.72 4.22C12.8606 4.07955 13.0512 4.00066 13.25 4.00066C13.4487 4.00066 13.6394 4.07955 13.78 4.22Z"></path></svg>
              <div class="select-menu-item-text">
                <span class="select-menu-item-heading">Not watching</span>
                <span class="description">Be notified only when participating or @mentioned.</span>
                <span class="hidden-select-button-text" data-menu-button-contents>
                  <svg class="octicon octicon-eye" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.67884 7.93165C2.09143 7.31094 2.9206 6.18152 4.0447 5.21477C5.17567 4.2421 6.52738 3.5 8.00001 3.5C9.47264 3.5 10.8244 4.2421 11.9553 5.21477C13.0794 6.18152 13.9086 7.31094 14.3212 7.93165C14.35 7.975 14.35 8.025 14.3212 8.06835C13.9086 8.68906 13.0794 9.81848 11.9553 10.7852C10.8244 11.7579 9.47264 12.5 8.00001 12.5C6.52738 12.5 5.17567 11.7579 4.0447 10.7852C2.9206 9.81848 2.09143 8.68906 1.67884 8.06835C1.65002 8.025 1.65002 7.975 1.67884 7.93165ZM8.00001 2C6.01865 2 4.32919 2.99167 3.06662 4.07751C1.79718 5.16926 0.880454 6.42307 0.429635 7.10129C0.0664231 7.64771 0.0664245 8.35229 0.429635 8.89871C0.880455 9.57693 1.79718 10.8307 3.06662 11.9225C4.32919 13.0083 6.01865 14 8.00001 14C9.98137 14 11.6708 13.0083 12.9334 11.9225C14.2028 10.8307 15.1196 9.57693 15.5704 8.89871C15.9336 8.35229 15.9336 7.64771 15.5704 7.10129C15.1196 6.42307 14.2028 5.16926 12.9334 4.07751C11.6708 2.99167 9.98137 2 8.00001 2ZM8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z"></path></svg>
                  Watch
                </span>
              </div>
            </button>

            <button type="submit" name="do" value="release_only" class="select-menu-item width-full" aria-checked="false" role="menuitemradio">
              <svg class="octicon octicon-check select-menu-item-icon" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M13.78 4.22C13.9204 4.36062 13.9993 4.55125 13.9993 4.75C13.9993 4.94875 13.9204 5.13937 13.78 5.28L6.53 12.53C6.38937 12.6704 6.19875 12.7493 6 12.7493C5.80125 12.7493 5.61062 12.6704 5.47 12.53L2.22 9.28C2.08752 9.13782 2.0154 8.94978 2.01882 8.75547C2.02225 8.56117 2.10096 8.37579 2.23838 8.23837C2.37579 8.10096 2.56118 8.02225 2.75548 8.01882C2.94978 8.01539 3.13782 8.08752 3.28 8.22L6 10.94L12.72 4.22C12.8606 4.07955 13.0512 4.00066 13.25 4.00066C13.4487 4.00066 13.6394 4.07955 13.78 4.22Z"></path></svg>
              <div class="select-menu-item-text">
                <span class="select-menu-item-heading">Releases only</span>
                <span class="description">Be notified of new releases, and when participating or @mentioned.</span>
                <span class="hidden-select-button-text" data-menu-button-contents>
                  <svg class="octicon octicon-eye" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.67884 7.93165C2.09143 7.31094 2.9206 6.18152 4.0447 5.21477C5.17567 4.2421 6.52738 3.5 8.00001 3.5C9.47264 3.5 10.8244 4.2421 11.9553 5.21477C13.0794 6.18152 13.9086 7.31094 14.3212 7.93165C14.35 7.975 14.35 8.025 14.3212 8.06835C13.9086 8.68906 13.0794 9.81848 11.9553 10.7852C10.8244 11.7579 9.47264 12.5 8.00001 12.5C6.52738 12.5 5.17567 11.7579 4.0447 10.7852C2.9206 9.81848 2.09143 8.68906 1.67884 8.06835C1.65002 8.025 1.65002 7.975 1.67884 7.93165ZM8.00001 2C6.01865 2 4.32919 2.99167 3.06662 4.07751C1.79718 5.16926 0.880454 6.42307 0.429635 7.10129C0.0664231 7.64771 0.0664245 8.35229 0.429635 8.89871C0.880455 9.57693 1.79718 10.8307 3.06662 11.9225C4.32919 13.0083 6.01865 14 8.00001 14C9.98137 14 11.6708 13.0083 12.9334 11.9225C14.2028 10.8307 15.1196 9.57693 15.5704 8.89871C15.9336 8.35229 15.9336 7.64771 15.5704 7.10129C15.1196 6.42307 14.2028 5.16926 12.9334 4.07751C11.6708 2.99167 9.98137 2 8.00001 2ZM8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z"></path></svg>
                  Unwatch releases
                </span>
              </div>
            </button>

            <button type="submit" name="do" value="subscribed" class="select-menu-item width-full" aria-checked="false" role="menuitemradio">
              <svg class="octicon octicon-check select-menu-item-icon" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M13.78 4.22C13.9204 4.36062 13.9993 4.55125 13.9993 4.75C13.9993 4.94875 13.9204 5.13937 13.78 5.28L6.53 12.53C6.38937 12.6704 6.19875 12.7493 6 12.7493C5.80125 12.7493 5.61062 12.6704 5.47 12.53L2.22 9.28C2.08752 9.13782 2.0154 8.94978 2.01882 8.75547C2.02225 8.56117 2.10096 8.37579 2.23838 8.23837C2.37579 8.10096 2.56118 8.02225 2.75548 8.01882C2.94978 8.01539 3.13782 8.08752 3.28 8.22L6 10.94L12.72 4.22C12.8606 4.07955 13.0512 4.00066 13.25 4.00066C13.4487 4.00066 13.6394 4.07955 13.78 4.22Z"></path></svg>
              <div class="select-menu-item-text">
                <span class="select-menu-item-heading">Watching</span>
                <span class="description">Be notified of all conversations.</span>
                <span class="hidden-select-button-text" data-menu-button-contents>
                  <svg class="octicon octicon-eye" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.67884 7.93165C2.09143 7.31094 2.9206 6.18152 4.0447 5.21477C5.17567 4.2421 6.52738 3.5 8.00001 3.5C9.47264 3.5 10.8244 4.2421 11.9553 5.21477C13.0794 6.18152 13.9086 7.31094 14.3212 7.93165C14.35 7.975 14.35 8.025 14.3212 8.06835C13.9086 8.68906 13.0794 9.81848 11.9553 10.7852C10.8244 11.7579 9.47264 12.5 8.00001 12.5C6.52738 12.5 5.17567 11.7579 4.0447 10.7852C2.9206 9.81848 2.09143 8.68906 1.67884 8.06835C1.65002 8.025 1.65002 7.975 1.67884 7.93165ZM8.00001 2C6.01865 2 4.32919 2.99167 3.06662 4.07751C1.79718 5.16926 0.880454 6.42307 0.429635 7.10129C0.0664231 7.64771 0.0664245 8.35229 0.429635 8.89871C0.880455 9.57693 1.79718 10.8307 3.06662 11.9225C4.32919 13.0083 6.01865 14 8.00001 14C9.98137 14 11.6708 13.0083 12.9334 11.9225C14.2028 10.8307 15.1196 9.57693 15.5704 8.89871C15.9336 8.35229 15.9336 7.64771 15.5704 7.10129C15.1196 6.42307 14.2028 5.16926 12.9334 4.07751C11.6708 2.99167 9.98137 2 8.00001 2ZM8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z"></path></svg>
                  Unwatch
                </span>
              </div>
            </button>

            <button type="submit" name="do" value="ignore" class="select-menu-item width-full" aria-checked="false" role="menuitemradio">
              <svg class="octicon octicon-check select-menu-item-icon" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M13.78 4.22C13.9204 4.36062 13.9993 4.55125 13.9993 4.75C13.9993 4.94875 13.9204 5.13937 13.78 5.28L6.53 12.53C6.38937 12.6704 6.19875 12.7493 6 12.7493C5.80125 12.7493 5.61062 12.6704 5.47 12.53L2.22 9.28C2.08752 9.13782 2.0154 8.94978 2.01882 8.75547C2.02225 8.56117 2.10096 8.37579 2.23838 8.23837C2.37579 8.10096 2.56118 8.02225 2.75548 8.01882C2.94978 8.01539 3.13782 8.08752 3.28 8.22L6 10.94L12.72 4.22C12.8606 4.07955 13.0512 4.00066 13.25 4.00066C13.4487 4.00066 13.6394 4.07955 13.78 4.22Z"></path></svg>
              <div class="select-menu-item-text">
                <span class="select-menu-item-heading">Ignoring</span>
                <span class="description">Never be notified.</span>
                <span class="hidden-select-button-text" data-menu-button-contents>
                  <svg class="octicon octicon-bell-slash" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.00005 1.5C7.00314 1.5 6.1046 1.91582 5.4662 2.58554C5.1804 2.88536 4.70566 2.89673 4.40584 2.61093C4.10602 2.32513 4.09465 1.85039 4.38045 1.55057C5.29016 0.596222 6.5761 0 8.00005 0C10.7615 0 13.0001 2.23858 13.0001 5V7.37362C13.0001 7.78783 12.6643 8.12362 12.2501 8.12362C11.8358 8.12362 11.5001 7.78783 11.5001 7.37362V5C11.5001 3.067 9.93305 1.5 8.00005 1.5ZM4.1824 4.3095L1.18994 2.14254C0.854447 1.8996 0.385538 1.97462 0.142598 2.31011C-0.100343 2.6456 -0.0253172 3.11451 0.310172 3.35745L3.00005 5.30529V7.94722C3.00005 7.99658 2.98544 8.04483 2.95807 8.0859L1.25493 10.6406C1.08874 10.8899 1.00005 11.1828 1.00005 11.4824C1.00005 12.3206 1.6795 13 2.51765 13H13.6261L14.8102 13.8574C15.1457 14.1004 15.6146 14.0254 15.8575 13.6899C16.1005 13.3544 16.0254 12.8855 15.6899 12.6425L14.3154 11.6472C14.3108 11.6438 14.3062 11.6405 14.3016 11.6372L4.19778 4.32063C4.1927 4.31686 4.18758 4.31314 4.1824 4.3095ZM11.5546 11.5L4.50005 6.3915V7.94722C4.50005 8.29272 4.39779 8.63048 4.20614 8.91795L2.50301 11.4726C2.50108 11.4755 2.50005 11.4789 2.50005 11.4824C2.50005 11.4862 2.50068 11.488 2.50113 11.489C2.50179 11.4906 2.50307 11.4927 2.50521 11.4948C2.50734 11.497 2.50947 11.4983 2.51103 11.4989C2.51209 11.4994 2.51383 11.5 2.51765 11.5H11.5546ZM8.00005 16C9.02013 16 9.86184 15.2363 9.98464 14.2495C10.0017 14.1125 9.88812 14 9.75005 14H6.25005C6.11198 14 5.99841 14.1125 6.01546 14.2495C6.13827 15.2363 6.97998 16 8.00005 16Z"></path></svg>
                  Stop ignoring
                </span>
              </div>
            </button>
          </div>
        </details-menu>
      </details>
        <a class="social-count js-social-count"
          href="/acmesh-official/acme.sh/watchers"
          aria-label="433 users are watching this repository">
          433
        </a>
</form>
  </li>

  <li>
      <div class="js-toggler-container js-social-container starring-container ">
    <form class="starred js-social-form" action="/acmesh-official/acme.sh/unstar" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="+YwvJRNUIn0IUqYaGRiBRGV4AFjzR5AaqcJwnV4jNytjEOlS98CX5OzhUX5sqYKLjETrQpOkiEChgS+ovAF41Q==" />
      <input type="hidden" name="context" value="repository"></input>
      <button type="submit" class="btn btn-sm btn-with-count  js-toggler-target" aria-label="Unstar this repository" title="Unstar acmesh-official/acme.sh" data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;UNSTAR_BUTTON&quot;,&quot;repository_id&quot;:48610662,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}" data-hydro-click-hmac="c9770f888499b99866505d5da1099ec881c284c4793d37aa9e1f93323d9f9840" data-ga-click="Repository, click unstar button, action:blob#show; text:Unstar">        <svg height="16" class="octicon octicon-star-fill" viewBox="0 0 16 16" version="1.1" width="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 0.25C8.14001 0.24991 8.27725 0.289014 8.39619 0.362887C8.51513 0.43676 8.61102 0.542452 8.673 0.668L10.555 4.483L14.765 5.095C14.9035 5.11511 15.0335 5.17355 15.1405 5.26372C15.2475 5.35388 15.3271 5.47218 15.3704 5.60523C15.4137 5.73829 15.4189 5.8808 15.3854 6.01665C15.3519 6.1525 15.2811 6.27628 15.181 6.374L12.135 9.344L12.854 13.536C12.8777 13.6739 12.8624 13.8157 12.8097 13.9454C12.757 14.0751 12.6691 14.1874 12.5559 14.2697C12.4427 14.352 12.3087 14.401 12.1691 14.4111C12.0295 14.4212 11.8899 14.3921 11.766 14.327L8 12.347L4.234 14.327C4.11018 14.392 3.97066 14.4211 3.83119 14.411C3.69171 14.4009 3.55784 14.352 3.44468 14.2699C3.33152 14.1877 3.24359 14.0755 3.19081 13.946C3.13803 13.8165 3.12251 13.6749 3.146 13.537L3.866 9.343L0.817997 6.374C0.717563 6.27632 0.646496 6.15247 0.612848 6.01647C0.579201 5.88047 0.584318 5.73777 0.627621 5.60453C0.670924 5.47129 0.75068 5.35284 0.857852 5.26261C0.965025 5.17238 1.09533 5.11397 1.234 5.094L5.444 4.483L7.327 0.668C7.38898 0.542452 7.48486 0.43676 7.6038 0.362887C7.72274 0.289014 7.85998 0.24991 8 0.25Z"></path></svg>

        Unstar
</button>        <a class="social-count js-social-count" href="/acmesh-official/acme.sh/stargazers"
           aria-label="17878 users starred this repository">
           17.9k
        </a>
</form>
    <form class="unstarred js-social-form" action="/acmesh-official/acme.sh/star" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="D5u6Y+ABHiszuw+rBn5tBms8QQsdqcYIQiUIOKN2AyLHY+QO+qekiT0GtmFVFZi+iU6Y+lEg0jd8pwBCgqDw+A==" />
      <input type="hidden" name="context" value="repository"></input>
      <button type="submit" class="btn btn-sm btn-with-count  js-toggler-target" aria-label="Unstar this repository" title="Star acmesh-official/acme.sh" data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;STAR_BUTTON&quot;,&quot;repository_id&quot;:48610662,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}" data-hydro-click-hmac="cb6732c098dcbb7c556d7e5528e681ac420ee7d907542fe660221afcdc84c467" data-ga-click="Repository, click star button, action:blob#show; text:Star">        <svg height="16" class="octicon octicon-star" viewBox="0 0 16 16" version="1.1" width="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.00001 0.25C8.14003 0.24991 8.27727 0.289014 8.39621 0.362887C8.51515 0.43676 8.61103 0.542452 8.67301 0.668L10.555 4.483L14.765 5.095C14.9035 5.11511 15.0336 5.17355 15.1405 5.26372C15.2475 5.35388 15.3272 5.47218 15.3704 5.60523C15.4137 5.73829 15.4189 5.8808 15.3854 6.01665C15.352 6.1525 15.2812 6.27628 15.181 6.374L12.135 9.344L12.854 13.536C12.8777 13.6739 12.8624 13.8157 12.8097 13.9454C12.757 14.0751 12.6691 14.1874 12.5559 14.2697C12.4427 14.352 12.3087 14.401 12.1691 14.4111C12.0295 14.4212 11.8899 14.3921 11.766 14.327L8.00001 12.347L4.23401 14.327C4.1102 14.392 3.97068 14.4211 3.8312 14.411C3.69173 14.4009 3.55785 14.352 3.44469 14.2699C3.33154 14.1877 3.2436 14.0755 3.19083 13.946C3.13805 13.8165 3.12252 13.6749 3.14601 13.537L3.86601 9.343L0.818012 6.374C0.717578 6.27632 0.646511 6.15247 0.612864 6.01647C0.579216 5.88047 0.584334 5.73777 0.627636 5.60453C0.670939 5.47129 0.750695 5.35284 0.857868 5.26261C0.96504 5.17238 1.09534 5.11397 1.23401 5.094L5.44401 4.483L7.32701 0.668C7.38899 0.542452 7.48488 0.43676 7.60382 0.362887C7.72276 0.289014 7.86 0.24991 8.00001 0.25ZM8.00001 2.695L6.61501 5.5C6.56123 5.6089 6.4818 5.70311 6.38356 5.77453C6.28531 5.84595 6.17119 5.89244 6.05101 5.91L2.95401 6.36L5.19401 8.544C5.28116 8.62886 5.34637 8.73365 5.384 8.84933C5.42163 8.96501 5.43056 9.0881 5.41001 9.208L4.88201 12.292L7.65101 10.836C7.75864 10.7794 7.87842 10.7499 8.00001 10.7499C8.12161 10.7499 8.24138 10.7794 8.34901 10.836L11.119 12.292L10.589 9.208C10.5685 9.0881 10.5774 8.96501 10.615 8.84933C10.6527 8.73365 10.7179 8.62886 10.805 8.544L13.045 6.361L9.94901 5.911C9.82883 5.89344 9.71471 5.84695 9.61647 5.77553C9.51822 5.70411 9.4388 5.6099 9.38501 5.501L8.00001 2.694V2.695Z"></path></svg>

        Star
</button>        <a class="social-count js-social-count" href="/acmesh-official/acme.sh/stargazers"
           aria-label="17878 users starred this repository">
          17.9k
        </a>
</form>  </div>

  </li>

  <li>
          <div class="float-left">
            <details class="details-reset details-overlay details-overlay-dark" >
                    <summary
                  class="btn btn-sm btn-with-count"
                  title="Fork your own copy of acmesh-official/acme.sh to your account"
                  data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;FORK_BUTTON&quot;,&quot;repository_id&quot;:48610662,&quot;originating_url&quot;:&quot;https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_gd.sh&quot;,&quot;user_id&quot;:3822774}}" data-hydro-click-hmac="e416c92dfadde9550352620966ba624717cfca39d9f36cf839573a9084cdda05" data-ga-click="Repository, show fork modal, action:blob#show; text:Fork">
                  <svg class="octicon octicon-repo-forked" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M5 3.25001C5 3.44892 4.92099 3.63969 4.78033 3.78034C4.63968 3.92099 4.44892 4.00001 4.25 4.00001C4.05109 4.00001 3.86033 3.92099 3.71967 3.78034C3.57902 3.63969 3.5 3.44892 3.5 3.25001C3.5 3.05109 3.57902 2.86033 3.71967 2.71968C3.86033 2.57902 4.05109 2.50001 4.25 2.50001C4.44892 2.50001 4.63968 2.57902 4.78033 2.71968C4.92099 2.86033 5 3.05109 5 3.25001ZM5 5.37201C5.50042 5.19509 5.92217 4.84696 6.19073 4.38915C6.45929 3.93134 6.55735 3.39333 6.4676 2.87021C6.37785 2.34709 6.10605 1.87253 5.70025 1.53043C5.29445 1.18832 4.78077 1.00069 4.25 1.00069C3.71924 1.00069 3.20556 1.18832 2.79976 1.53043C2.39396 1.87253 2.12216 2.34709 2.03241 2.87021C1.94265 3.39333 2.04072 3.93134 2.30928 4.38915C2.57784 4.84696 2.99959 5.19509 3.5 5.37201V6.25001C3.5 6.84674 3.73706 7.41904 4.15901 7.841C4.58097 8.26295 5.15327 8.50001 5.75 8.50001H7.25V10.628C6.74932 10.8049 6.3273 11.1532 6.05855 11.6112C5.78981 12.0692 5.69164 12.6075 5.78139 13.1309C5.87115 13.6543 6.14306 14.1291 6.54905 14.4714C6.95504 14.8136 7.46897 15.0014 8 15.0014C8.53104 15.0014 9.04497 14.8136 9.45096 14.4714C9.85695 14.1291 10.1289 13.6543 10.2186 13.1309C10.3084 12.6075 10.2102 12.0692 9.94146 11.6112C9.67271 11.1532 9.25069 10.8049 8.75 10.628V8.50001H10.25C10.8467 8.50001 11.419 8.26295 11.841 7.841C12.263 7.41904 12.5 6.84674 12.5 6.25001V5.37201C13.0004 5.19509 13.4222 4.84696 13.6907 4.38915C13.9593 3.93134 14.0574 3.39333 13.9676 2.87021C13.8778 2.34709 13.6061 1.87253 13.2002 1.53043C12.7944 1.18832 12.2808 1.00069 11.75 1.00069C11.2192 1.00069 10.7056 1.18832 10.2998 1.53043C9.89396 1.87253 9.62216 2.34709 9.53241 2.87021C9.44265 3.39333 9.54072 3.93134 9.80928 4.38915C10.0778 4.84696 10.4996 5.19509 11 5.37201V6.25001C11 6.44892 10.921 6.63969 10.7803 6.78034C10.6397 6.92099 10.4489 7.00001 10.25 7.00001H5.75C5.55109 7.00001 5.36033 6.92099 5.21967 6.78034C5.07902 6.63969 5 6.44892 5 6.25001V5.37201ZM8.75 12.75C8.75 12.9489 8.67099 13.1397 8.53033 13.2803C8.38968 13.421 8.19892 13.5 8 13.5C7.80109 13.5 7.61033 13.421 7.46967 13.2803C7.32902 13.1397 7.25 12.9489 7.25 12.75C7.25 12.5511 7.32902 12.3603 7.46967 12.2197C7.61033 12.079 7.80109 12 8 12C8.19892 12 8.38968 12.079 8.53033 12.2197C8.67099 12.3603 8.75 12.5511 8.75 12.75ZM11.75 4.00001C11.9489 4.00001 12.1397 3.92099 12.2803 3.78034C12.421 3.63969 12.5 3.44892 12.5 3.25001C12.5 3.05109 12.421 2.86033 12.2803 2.71968C12.1397 2.57902 11.9489 2.50001 11.75 2.50001C11.5511 2.50001 11.3603 2.57902 11.2197 2.71968C11.079 2.86033 11 3.05109 11 3.25001C11 3.44892 11.079 3.63969 11.2197 3.78034C11.3603 3.92099 11.5511 4.00001 11.75 4.00001Z"></path></svg>
                  Fork
                </summary>

  <details-dialog
    class="Box d-flex flex-column anim-fade-in fast Box--overlay"
      src="/acmesh-official/acme.sh/fork?fragment=1"
      preload
    >
    <div class="Box-header">
      <button class="Box-btn-octicon btn-octicon float-right" type="button" aria-label="Close dialog" data-close-dialog>
        <svg height="16" class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>

      </button>
      <h3 class="Box-title">Fork acme.sh</h3>
    </div>
      
              <div class="text-center overflow-auto">
                <include-fragment>
                  <div class="octocat-spinner my-5" aria-label="Loading..."></div>
                  <p class="f5 text-gray">If this dialog fails to load, you can visit <a href="/acmesh-official/acme.sh/fork">the fork page</a> directly.</p>
                </include-fragment>
              </div>

  </details-dialog>
</details>
          </div>

    <a href="/acmesh-official/acme.sh/network/members" class="social-count"
       aria-label="2408 users forked this repository">
      2.4k
    </a>
  </li>
</ul>

    </div>
      <nav class="js-repo-nav js-sidenav-container-pjax clearfix hx_reponav reponav p-responsive d-none d-lg-block container-lg"
     itemscope
     itemtype="http://schema.org/BreadcrumbList"
    aria-label="Repository"
     data-pjax="#js-repo-pjax-container">
  <ul class="list-style-none">
    <li  itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a class="js-selected-navigation-item selected reponav-item" itemprop="url" data-hotkey="g c" aria-current="page" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches repo_packages repo_deployments /acmesh-official/acme.sh" href="/acmesh-official/acme.sh">
        <div class="d-inline"><svg class="octicon octicon-code" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.71967 3.21967C5.01256 2.92678 5.48744 2.92678 5.78033 3.21967C6.07322 3.51256 6.07322 3.98744 5.78033 4.28033L2.06066 8L5.78033 11.7197C6.07322 12.0126 6.07322 12.4874 5.78033 12.7803C5.48744 13.0732 5.01256 13.0732 4.71967 12.7803L0.46967 8.53033C0.176777 8.23744 0.176777 7.76256 0.46967 7.46967L4.71967 3.21967ZM11.2803 3.21967C10.9874 2.92678 10.5126 2.92678 10.2197 3.21967C9.92678 3.51256 9.92678 3.98744 10.2197 4.28033L13.9393 8L10.2197 11.7197C9.92678 12.0126 9.92678 12.4874 10.2197 12.7803C10.5126 13.0732 10.9874 13.0732 11.2803 12.7803L15.5303 8.53033C15.8232 8.23744 15.8232 7.76256 15.5303 7.46967L11.2803 3.21967Z"></path></svg></div>
        <span itemprop="name">Code</span>
        <meta itemprop="position" content="1">
</a>    </li>

      <li  itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" data-hotkey="g i" class="js-selected-navigation-item reponav-item" data-selected-links="repo_issues repo_labels repo_milestones /acmesh-official/acme.sh/issues" href="/acmesh-official/acme.sh/issues">
          <div class="d-inline"><svg class="octicon octicon-issue-opened" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 1.5C6.27609 1.5 4.62279 2.18482 3.40381 3.40381C2.18482 4.62279 1.5 6.27609 1.5 8C1.5 9.72391 2.18482 11.3772 3.40381 12.5962C4.62279 13.8152 6.27609 14.5 8 14.5C9.72391 14.5 11.3772 13.8152 12.5962 12.5962C13.8152 11.3772 14.5 9.72391 14.5 8C14.5 6.27609 13.8152 4.62279 12.5962 3.40381C11.3772 2.18482 9.72391 1.5 8 1.5ZM0 8C0 5.87827 0.842855 3.84344 2.34315 2.34315C3.84344 0.842855 5.87827 0 8 0C10.1217 0 12.1566 0.842855 13.6569 2.34315C15.1571 3.84344 16 5.87827 16 8C16 10.1217 15.1571 12.1566 13.6569 13.6569C12.1566 15.1571 10.1217 16 8 16C5.87827 16 3.84344 15.1571 2.34315 13.6569C0.842855 12.1566 0 10.1217 0 8ZM9 11C9 11.2652 8.89464 11.5196 8.70711 11.7071C8.51957 11.8946 8.26522 12 8 12C7.73478 12 7.48043 11.8946 7.29289 11.7071C7.10536 11.5196 7 11.2652 7 11C7 10.7348 7.10536 10.4804 7.29289 10.2929C7.48043 10.1054 7.73478 10 8 10C8.26522 10 8.51957 10.1054 8.70711 10.2929C8.89464 10.4804 9 10.7348 9 11ZM8.75 4.75C8.75 4.55109 8.67098 4.36032 8.53033 4.21967C8.38968 4.07902 8.19891 4 8 4C7.80109 4 7.61032 4.07902 7.46967 4.21967C7.32902 4.36032 7.25 4.55109 7.25 4.75V8.25C7.25 8.44891 7.32902 8.63968 7.46967 8.78033C7.61032 8.92098 7.80109 9 8 9C8.19891 9 8.38968 8.92098 8.53033 8.78033C8.67098 8.63968 8.75 8.44891 8.75 8.25V4.75Z"></path></svg></div>
          <span itemprop="name">Issues</span>
          <span class="Counter">520</span>
          <meta itemprop="position" content="2">
</a>      </li>

    <li  itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a data-hotkey="g p" data-skip-pjax="true" itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_pulls checks /acmesh-official/acme.sh/pulls" href="/acmesh-official/acme.sh/pulls">
        <div class="d-inline"><svg class="octicon octicon-git-pull-request" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.17674 3.07322L9.57318 0.676753C9.73068 0.51926 9.99996 0.630802 9.99996 0.853529V5.64642C9.99996 5.86915 9.73068 5.98069 9.57319 5.8232L7.17674 3.42677C7.07911 3.32914 7.07911 3.17085 7.17674 3.07322ZM3.75 2.5C3.33579 2.5 3 2.83579 3 3.25C3 3.66421 3.33579 4 3.75 4C4.16421 4 4.5 3.66421 4.5 3.25C4.5 2.83579 4.16421 2.5 3.75 2.5ZM1.5 3.25C1.5 2.00736 2.50736 1 3.75 1C4.99264 1 6 2.00736 6 3.25C6 4.22966 5.37389 5.06309 4.5 5.37197V10.628C5.37389 10.9369 6 11.7703 6 12.75C6 13.9926 4.99264 15 3.75 15C2.50736 15 1.5 13.9926 1.5 12.75C1.5 11.7703 2.12611 10.9369 3 10.628V5.37197C2.12611 5.06309 1.5 4.22966 1.5 3.25ZM11 2.5H10V4H11C11.5523 4 12 4.44772 12 5V10.628C11.1261 10.9369 10.5 11.7703 10.5 12.75C10.5 13.9926 11.5074 15 12.75 15C13.9926 15 15 13.9926 15 12.75C15 11.7703 14.3739 10.9369 13.5 10.628V5C13.5 3.61929 12.3807 2.5 11 2.5ZM12 12.75C12 12.3358 12.3358 12 12.75 12C13.1642 12 13.5 12.3358 13.5 12.75C13.5 13.1642 13.1642 13.5 12.75 13.5C12.3358 13.5 12 13.1642 12 12.75ZM3.75 12C3.33579 12 3 12.3358 3 12.75C3 13.1642 3.33579 13.5 3.75 13.5C4.16421 13.5 4.5 13.1642 4.5 12.75C4.5 12.3358 4.16421 12 3.75 12Z"></path></svg></div>
        <span itemprop="name">Pull requests</span>
        <span class="Counter">129</span>
        <meta itemprop="position" content="4">
</a>    </li>


      <li itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement" class="position-relative float-left ">
        <a data-hotkey="g w" data-skip-pjax="true" class="js-selected-navigation-item reponav-item" data-selected-links="repo_actions /acmesh-official/acme.sh/actions" href="/acmesh-official/acme.sh/actions">
          <div class="d-inline"><svg class="octicon octicon-play" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.5 8C1.5 4.41015 4.41015 1.5 8 1.5C11.5899 1.5 14.5 4.41015 14.5 8C14.5 11.5899 11.5899 14.5 8 14.5C4.41015 14.5 1.5 11.5899 1.5 8ZM8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0ZM6.37862 5.22717C6.21199 5.1272 6 5.24722 6 5.44155V10.5585C6 10.7528 6.21199 10.8728 6.37862 10.7728L10.6427 8.21437C10.8045 8.11727 10.8045 7.88273 10.6427 7.78563L6.37862 5.22717Z"></path></svg></div>
          Actions
</a>
      </li>

      <li >
        <a data-hotkey="g b" class="js-selected-navigation-item reponav-item" data-selected-links="repo_projects new_repo_project repo_project /acmesh-official/acme.sh/projects" href="/acmesh-official/acme.sh/projects">
          <div class="d-inline"><svg class="octicon octicon-project" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.75 0C0.783502 0 0 0.783501 0 1.75V14.25C0 15.2165 0.783501 16 1.75 16H14.25C15.2165 16 16 15.2165 16 14.25V1.75C16 0.783502 15.2165 0 14.25 0H1.75ZM1.5 1.75C1.5 1.61193 1.61193 1.5 1.75 1.5H14.25C14.3881 1.5 14.5 1.61193 14.5 1.75V14.25C14.5 14.3881 14.3881 14.5 14.25 14.5H1.75C1.61193 14.5 1.5 14.3881 1.5 14.25V1.75ZM11.75 3C11.3358 3 11 3.33579 11 3.75V11.25C11 11.6642 11.3358 12 11.75 12C12.1642 12 12.5 11.6642 12.5 11.25V3.75C12.5 3.33579 12.1642 3 11.75 3ZM3.5 3.75C3.5 3.33579 3.83579 3 4.25 3C4.66421 3 5 3.33579 5 3.75V9.25C5 9.66421 4.66421 10 4.25 10C3.83579 10 3.5 9.66421 3.5 9.25V3.75ZM8 3C7.58579 3 7.25 3.33579 7.25 3.75V7.25C7.25 7.66421 7.58579 8 8 8C8.41421 8 8.75 7.66421 8.75 7.25V3.75C8.75 3.33579 8.41421 3 8 3Z"></path></svg></div>
          Projects
          <span class="Counter">0</span>
</a>      </li>

      <li >
        <a class="js-selected-navigation-item reponav-item" data-hotkey="g w" data-selected-links="repo_wiki /acmesh-official/acme.sh/wiki" href="/acmesh-official/acme.sh/wiki">
          <div class="d-inline"><svg class="octicon octicon-book" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M0 1.75C0 1.33579 0.335786 1 0.75 1H5.00286C6.23012 1 7.31979 1.58958 8.00393 2.50106C8.68803 1.58962 9.77766 1 11.005 1H15.25C15.6642 1 16 1.33579 16 1.75V12.25C16 12.6642 15.6642 13 15.25 13H10.7426C10.1459 13 9.57361 13.2371 9.15165 13.659L8.53033 14.2803C8.23744 14.5732 7.76256 14.5732 7.46967 14.2803L6.84835 13.659C6.42639 13.2371 5.8541 13 5.25736 13H0.75C0.335786 13 0 12.6642 0 12.25V1.75ZM8.755 4.75C8.755 3.50736 9.76236 2.5 11.005 2.5H14.5V11.5H10.7426C10.0326 11.5 9.34339 11.7014 8.75124 12.0724L8.755 4.75ZM7.25124 12.074L7.255 7.00071L7.25285 4.74786C7.25167 3.50605 6.24466 2.5 5.00286 2.5H1.5V11.5H5.25736C5.96836 11.5 6.65854 11.7019 7.25124 12.074Z"></path></svg></div>
          Wiki
</a>      </li>

      <li >
        <a data-skip-pjax="true" class="js-selected-navigation-item reponav-item" data-selected-links="security overview alerts policy token_scanning code_scanning /acmesh-official/acme.sh/security" href="/acmesh-official/acme.sh/security">
          <div class="d-inline"><svg class="octicon octicon-shield" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.46664 0.133062C7.81355 0.0220518 8.18645 0.0220524 8.53336 0.133063L13.7834 1.81306C14.5082 2.045 15 2.71878 15 3.4798V6.99985C15 8.5659 14.6808 10.1823 13.6968 11.682C12.7137 13.1805 11.1116 14.4946 8.66493 15.5367C8.24091 15.7173 7.75909 15.7173 7.33508 15.5367C4.88836 14.4946 3.28631 13.1805 2.3032 11.682C1.31923 10.1823 1 8.5659 1 6.99985V3.4798C1 2.71878 1.49183 2.045 2.21664 1.81306L7.46664 0.133062ZM8.07619 1.5617C8.02664 1.54584 7.97336 1.54584 7.92381 1.5617L2.67381 3.2417C2.57026 3.27483 2.5 3.37109 2.5 3.4798V6.99985C2.5 8.35818 2.77465 9.66618 3.55737 10.8592C4.34094 12.0535 5.67838 13.2007 7.92287 14.1567C7.97134 14.1773 8.02866 14.1773 8.07713 14.1567C10.3216 13.2007 11.6591 12.0535 12.4426 10.8592C13.2253 9.66618 13.5 8.35818 13.5 6.99985V3.4798C13.5 3.37109 13.4297 3.27483 13.3262 3.2417L8.07619 1.5617ZM9 10.4999C9 11.0522 8.55228 11.4999 8 11.4999C7.44772 11.4999 7 11.0522 7 10.4999C7 9.94759 7.44772 9.49988 8 9.49988C8.55228 9.49988 9 9.94759 9 10.4999ZM8.75 4.74988C8.75 4.33566 8.41421 3.99988 8 3.99988C7.58579 3.99988 7.25 4.33566 7.25 4.74988V7.74988C7.25 8.16409 7.58579 8.49988 8 8.49988C8.41421 8.49988 8.75 8.16409 8.75 7.74988V4.74988Z"></path></svg></div>
          Security
              <span class="Counter js-security-tab-count" data-url="/acmesh-official/acme.sh/security/overall-count" hidden></span>
</a>      </li>

      <li >
        <a class="js-selected-navigation-item reponav-item" data-selected-links="repo_graphs repo_contributors dependency_graph dependabot_updates pulse people /acmesh-official/acme.sh/pulse" href="/acmesh-official/acme.sh/pulse">
          <div class="d-inline"><svg class="octicon octicon-graph" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.5 1.75C1.5 1.33579 1.16421 1 0.75 1C0.335786 1 0 1.33579 0 1.75V14.25C0 14.6642 0.335786 15 0.75 15H15.25C15.6642 15 16 14.6642 16 14.25C16 13.8358 15.6642 13.5 15.25 13.5H1.5V1.75ZM15.7803 4.28033C16.0732 3.98744 16.0732 3.51256 15.7803 3.21967C15.4874 2.92678 15.0126 2.92678 14.7197 3.21967L10 7.93934L7.53033 5.46967C7.23744 5.17678 6.76256 5.17678 6.46967 5.46967L3.21967 8.71967C2.92678 9.01256 2.92678 9.48744 3.21967 9.78033C3.51256 10.0732 3.98744 10.0732 4.28033 9.78033L7 7.06066L9.46967 9.53033C9.61032 9.67098 9.80109 9.75 10 9.75C10.1989 9.75 10.3897 9.67098 10.5303 9.53033L15.7803 4.28033Z"></path></svg></div>
          Insights
</a>      </li>


  </ul>
</nav>

  <div class="reponav-wrapper reponav-small d-lg-none">
  <nav class="reponav js-reponav text-center no-wrap"
       itemscope
       itemtype="http://schema.org/BreadcrumbList">

    <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a class="js-selected-navigation-item selected reponav-item" itemprop="url" aria-current="page" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches repo_packages repo_deployments /acmesh-official/acme.sh" href="/acmesh-official/acme.sh">
        <span itemprop="name">Code</span>
        <meta itemprop="position" content="1">
</a>    </span>

      <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_issues repo_labels repo_milestones /acmesh-official/acme.sh/issues" href="/acmesh-official/acme.sh/issues">
          <span itemprop="name">Issues</span>
          <span class="Counter">520</span>
          <meta itemprop="position" content="2">
</a>      </span>

    <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_pulls checks /acmesh-official/acme.sh/pulls" href="/acmesh-official/acme.sh/pulls">
        <span itemprop="name">Pull requests</span>
        <span class="Counter">129</span>
        <meta itemprop="position" content="4">
</a>    </span>


      <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_projects new_repo_project repo_project /acmesh-official/acme.sh/projects" href="/acmesh-official/acme.sh/projects">
          <span itemprop="name">Projects</span>
          <span class="Counter">0</span>
          <meta itemprop="position" content="5">
</a>      </span>

      <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_actions /acmesh-official/acme.sh/actions" href="/acmesh-official/acme.sh/actions">
          <span itemprop="name">Actions</span>
          <meta itemprop="position" content="6">
</a>      </span>

      <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="repo_wiki /acmesh-official/acme.sh/wiki" href="/acmesh-official/acme.sh/wiki">
          <span itemprop="name">Wiki</span>
          <meta itemprop="position" content="7">
</a>      </span>

      <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="security overview alerts policy token_scanning code_scanning /acmesh-official/acme.sh/security" href="/acmesh-official/acme.sh/security">
        <span itemprop="name">Security</span>
            <span class="Counter js-security-deferred-tab-count" hidden></span>
        <meta itemprop="position" content="8">
</a>
      <a class="js-selected-navigation-item reponav-item" data-selected-links="pulse /acmesh-official/acme.sh/pulse" href="/acmesh-official/acme.sh/pulse">
        Pulse
</a>
      <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
        <a itemprop="url" class="js-selected-navigation-item reponav-item" data-selected-links="community /acmesh-official/acme.sh/community" href="/acmesh-official/acme.sh/community">
          Community
</a>      </span>

  </nav>
</div>


  </div>

  

  <include-fragment class="js-notification-shelf-include-fragment" data-base-src="https://github.com/notifications/beta/shelf"></include-fragment>


<div class="container-lg clearfix new-discussion-timeline  p-responsive">
  <div class="repository-content ">

    
    

  


    <a class="d-none js-permalink-shortcut" data-hotkey="y" href="/acmesh-official/acme.sh/blob/9190fdd42c5332f8821ce3f0de91cf0d18fa07d5/dnsapi/dns_gd.sh">Permalink</a>

    <!-- blob contrib key: blob_contributors:v22:46ec1322e166703dff0b5e3d59ade3ee -->
    

    <div class="d-flex flex-items-start flex-shrink-0 flex-column flex-md-row pb-3">
      <span class="d-flex flex-justify-between width-full width-md-auto">
        
<details class="details-reset details-overlay branch-select-menu " id="branch-select-menu">
  <summary class="btn css-truncate btn-sm"
           data-hotkey="w"
           title="Switch branches or tags">
    <i>Branch:</i>
    <span class="css-truncate-target" data-menu-button>master</span>
    <span class="dropdown-caret"></span>
  </summary>

  <details-menu class="SelectMenu SelectMenu--hasFilter" src="/acmesh-official/acme.sh/refs/master/dnsapi/dns_gd.sh?source_action=show&amp;source_controller=blob" preload>
    <div class="SelectMenu-modal">
      <include-fragment class="SelectMenu-loading" aria-label="Menu is loading">
        <svg class="octicon octicon-octoface anim-pulse" height="32" viewBox="0 0 16 16" version="1.1" width="32" aria-hidden="true"><path fill-rule="evenodd" d="M14.7 5.34c.13-.32.55-1.59-.13-3.31 0 0-1.05-.33-3.44 1.3-1-.28-2.07-.32-3.13-.32s-2.13.04-3.13.32c-2.39-1.64-3.44-1.3-3.44-1.3-.68 1.72-.26 2.99-.13 3.31C.49 6.21 0 7.33 0 8.69 0 13.84 3.33 15 7.98 15S16 13.84 16 8.69c0-1.36-.49-2.48-1.3-3.35zM8 14.02c-3.3 0-5.98-.15-5.98-3.35 0-.76.38-1.48 1.02-2.07 1.07-.98 2.9-.46 4.96-.46 2.07 0 3.88-.52 4.96.46.65.59 1.02 1.3 1.02 2.07 0 3.19-2.68 3.35-5.98 3.35zM5.49 9.01c-.66 0-1.2.8-1.2 1.78s.54 1.79 1.2 1.79c.66 0 1.2-.8 1.2-1.79s-.54-1.78-1.2-1.78zm5.02 0c-.66 0-1.2.79-1.2 1.78s.54 1.79 1.2 1.79c.66 0 1.2-.8 1.2-1.79s-.53-1.78-1.2-1.78z"></path></svg>
      </include-fragment>
    </div>
  </details-menu>
</details>

        <div class="BtnGroup flex-shrink-0 d-md-none">
          <a href="/acmesh-official/acme.sh/find/master"
                class="js-pjax-capture-input btn btn-sm BtnGroup-item"
                data-pjax
                data-hotkey="t">
            Find file
          </a>
          <clipboard-copy value="dnsapi/dns_gd.sh" class="btn btn-sm BtnGroup-item">
            Copy path
          </clipboard-copy>
        </div>
      </span>
      <h2 id="blob-path" class="breadcrumb flex-auto min-width-0 text-normal flex-md-self-center ml-md-2 mr-md-3 my-2 my-md-0">
        <span class="js-repo-root text-bold"><span class="js-path-segment d-inline-block wb-break-all"><a data-pjax="true" href="/acmesh-official/acme.sh"><span>acme.sh</span></a></span></span><span class="separator">/</span><span class="js-path-segment d-inline-block wb-break-all"><a data-pjax="true" href="/acmesh-official/acme.sh/tree/master/dnsapi"><span>dnsapi</span></a></span><span class="separator">/</span><strong class="final-path">dns_gd.sh</strong>
      </h2>

      <div class="BtnGroup flex-shrink-0 d-none d-md-inline-block">
        <a href="/acmesh-official/acme.sh/find/master"
              class="js-pjax-capture-input btn btn-sm BtnGroup-item"
              data-pjax
              data-hotkey="t">
          Find file
        </a>
        <clipboard-copy value="dnsapi/dns_gd.sh" class="btn btn-sm BtnGroup-item">
          Copy path
        </clipboard-copy>
      </div>
    </div>



    <include-fragment src="/acmesh-official/acme.sh/contributors/master/dnsapi/dns_gd.sh" class="Box Box--condensed commit-loader">
      <div class="Box-body bg-blue-light f6">
        Fetching contributors&hellip;
      </div>

      <div class="Box-body d-flex flex-items-center" >
        <img alt="" class="loader-loading mr-2" src="https://github.githubassets.com/images/spinners/octocat-spinner-32-EAF2F5.gif" width="16" height="16" />
        <span class="text-red h6 loader-error">Cannot retrieve contributors at this time</span>
      </div>
</include-fragment>





    <div class="Box mt-3 position-relative
      ">
      
<div class="Box-header py-2 d-flex flex-column flex-shrink-0 flex-md-row flex-md-items-center">
  <div class="text-mono f6 flex-auto pr-3 flex-order-2 flex-md-order-1 mt-2 mt-md-0">

      <span class="file-mode" title="File mode">executable file</span>
      <span class="file-info-divider"></span>
      176 lines (149 sloc)
      <span class="file-info-divider"></span>
    4.08 KB
  </div>

  <div class="d-flex py-1 py-md-0 flex-auto flex-order-1 flex-md-order-2 flex-sm-grow-0 flex-justify-between">

    <div class="BtnGroup">
      <a id="raw-url" class="btn btn-sm BtnGroup-item" href="/acmesh-official/acme.sh/raw/master/dnsapi/dns_gd.sh">Raw</a>
        <a class="btn btn-sm js-update-url-with-hash BtnGroup-item" data-hotkey="b" href="/acmesh-official/acme.sh/blame/master/dnsapi/dns_gd.sh">Blame</a>
      <a rel="nofollow" class="btn btn-sm BtnGroup-item" href="/acmesh-official/acme.sh/commits/master/dnsapi/dns_gd.sh">History</a>
    </div>


    <div>
          <a class="btn-octicon tooltipped tooltipped-nw js-remove-unless-platform"
             data-platforms="windows,mac"
             href="https://desktop.github.com"
             aria-label="Open this file in GitHub Desktop"
             data-ga-click="Repository, open with desktop">
              <svg class="octicon octicon-device-desktop" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M1.75 2.5H14.25C14.3881 2.5 14.5 2.61193 14.5 2.75V10.25C14.5 10.3881 14.3881 10.5 14.25 10.5H1.75C1.61193 10.5 1.5 10.3881 1.5 10.25V2.75C1.5 2.61193 1.61193 2.5 1.75 2.5ZM14.25 1H1.75C0.783502 1 0 1.7835 0 2.75V10.25C0 11.2165 0.783502 12 1.75 12H5.47703C5.37794 13.041 4.95684 13.8724 4.18494 14.7568C3.99156 14.9784 3.94553 15.2926 4.06724 15.5604C4.18894 15.8281 4.4559 16 4.75001 16H11.25C11.5441 16 11.8111 15.8281 11.9328 15.5604C12.0545 15.2926 12.0085 14.9784 11.8151 14.7568C11.0432 13.8724 10.6221 13.041 10.523 12H14.25C15.2165 12 16 11.2165 16 10.25V2.75C16 1.7835 15.2165 1 14.25 1ZM9.01784 12H6.98218C6.91392 12.9377 6.651 13.7473 6.21733 14.5H9.78269C9.34903 13.7473 9.08611 12.9377 9.01784 12Z"></path></svg>
          </a>

          <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="inline-form js-update-url-with-hash" action="/acmesh-official/acme.sh/edit/master/dnsapi/dns_gd.sh" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="sFqcFnv1d1O2gHWHAaoaRkjWdlc/2cH7RvT0wvdUFyDXoGl5fkrr0OYX8C94fO+Vh5qhz1tSBFWIi/E6Vb9hyQ==" />
            <button class="btn-octicon tooltipped tooltipped-nw" type="submit"
              aria-label="Fork this project and edit the file" data-hotkey="e" data-disable-with>
              <svg class="octicon octicon-pencil" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.0126 1.42678C11.696 0.74336 12.804 0.743362 13.4874 1.42678L14.5732 2.51257C15.2566 3.19598 15.2566 4.30402 14.5732 4.98744L5.96355 13.5971C5.75325 13.8074 5.49283 13.9606 5.20687 14.0423L1.95603 14.9711C1.69413 15.046 1.41226 14.9729 1.21966 14.7803C1.02706 14.5877 0.954017 14.3059 1.02884 14.044L1.95766 10.7931C2.03936 10.5072 2.19259 10.2467 2.40289 10.0364L11.0126 1.42678ZM12.4268 2.48744C12.3291 2.38981 12.1708 2.38981 12.0732 2.48744L10.8106 3.75L12.25 5.18934L13.5126 3.92678C13.6102 3.82915 13.6102 3.67086 13.5126 3.57323L12.4268 2.48744ZM11.1893 6.25L9.74999 4.81066L3.46355 11.0971C3.43351 11.1271 3.41162 11.1643 3.39994 11.2052L2.842 13.158L4.79479 12.6C4.83564 12.5884 4.87284 12.5665 4.90289 12.5364L11.1893 6.25Z"></path></svg>
            </button>
</form>
          <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="inline-form" action="/acmesh-official/acme.sh/delete/master/dnsapi/dns_gd.sh" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="AJPvtfbFtifY3Xj0LW9FvDv4IHgUbyLSk0ciAhpJrrA9eYdnqvKEb79bM4xTgQUU1XtEXU+F/oEcbHC20PktZA==" />
            <button class="btn-octicon btn-octicon-danger tooltipped tooltipped-nw" type="submit"
              aria-label="Fork this project and delete the file" data-disable-with>
              <svg class="octicon octicon-trashcan" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M6.5 1.75C6.5 1.61193 6.61193 1.5 6.75 1.5H9.25C9.38807 1.5 9.5 1.61193 9.5 1.75V3H6.5V1.75ZM11 1.75V3H13.25C13.6642 3 14 3.33579 14 3.75C14 4.16421 13.6642 4.5 13.25 4.5H2.75C2.33579 4.5 2 4.16421 2 3.75C2 3.33579 2.33579 3 2.75 3H5V1.75C5 0.783502 5.7835 0 6.75 0H9.25C10.2165 0 11 0.783502 11 1.75ZM4.49627 6.67537C4.45506 6.26321 4.08753 5.9625 3.67537 6.00372C3.26321 6.04493 2.9625 6.41247 3.00372 6.82462L3.66367 13.4241C3.75313 14.3187 4.50592 15 5.40498 15H10.595C11.4941 15 12.2469 14.3187 12.3363 13.4241L12.9963 6.82462C13.0375 6.41247 12.7368 6.04493 12.3246 6.00372C11.9125 5.9625 11.5449 6.26321 11.5037 6.67537L10.8438 13.2749C10.831 13.4027 10.7234 13.5 10.595 13.5H5.40498C5.27655 13.5 5.169 13.4027 5.15622 13.2749L4.49627 6.67537Z"></path></svg>
            </button>
</form>    </div>
  </div>
</div>



      

  <div itemprop="text" class="Box-body p-0 blob-wrapper data type-shell ">
      
<table class="highlight tab-size js-file-line-container" data-tab-size="8" data-paste-markdown-skip>
      <tr>
        <td id="L1" class="blob-num js-line-number" data-line-number="1"></td>
        <td id="LC1" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#!</span>/usr/bin/env sh</span></td>
      </tr>
      <tr>
        <td id="L2" class="blob-num js-line-number" data-line-number="2"></td>
        <td id="LC2" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L3" class="blob-num js-line-number" data-line-number="3"></td>
        <td id="LC3" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>Godaddy domain api</span></td>
      </tr>
      <tr>
        <td id="L4" class="blob-num js-line-number" data-line-number="4"></td>
        <td id="LC4" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span></span></td>
      </tr>
      <tr>
        <td id="L5" class="blob-num js-line-number" data-line-number="5"></td>
        <td id="LC5" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>GD_Key=&quot;sdfsdfsdfljlbjkljlkjsdfoiwje&quot;</span></td>
      </tr>
      <tr>
        <td id="L6" class="blob-num js-line-number" data-line-number="6"></td>
        <td id="LC6" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span></span></td>
      </tr>
      <tr>
        <td id="L7" class="blob-num js-line-number" data-line-number="7"></td>
        <td id="LC7" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>GD_Secret=&quot;asdfsdfsfsdfsdfdfsdf&quot;</span></td>
      </tr>
      <tr>
        <td id="L8" class="blob-num js-line-number" data-line-number="8"></td>
        <td id="LC8" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L9" class="blob-num js-line-number" data-line-number="9"></td>
        <td id="LC9" class="blob-code blob-code-inner js-file-line">GD_Api=<span class="pl-s"><span class="pl-pds">&quot;</span>https://api.godaddy.com/v1<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L10" class="blob-num js-line-number" data-line-number="10"></td>
        <td id="LC10" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L11" class="blob-num js-line-number" data-line-number="11"></td>
        <td id="LC11" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>#######  Public functions #####################</span></td>
      </tr>
      <tr>
        <td id="L12" class="blob-num js-line-number" data-line-number="12"></td>
        <td id="LC12" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L13" class="blob-num js-line-number" data-line-number="13"></td>
        <td id="LC13" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>Usage: add  _acme-challenge.www.domain.com   &quot;XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs&quot;</span></td>
      </tr>
      <tr>
        <td id="L14" class="blob-num js-line-number" data-line-number="14"></td>
        <td id="LC14" class="blob-code blob-code-inner js-file-line"><span class="pl-en">dns_gd_add</span>() {</td>
      </tr>
      <tr>
        <td id="L15" class="blob-num js-line-number" data-line-number="15"></td>
        <td id="LC15" class="blob-code blob-code-inner js-file-line">  fulldomain=<span class="pl-smi">$1</span></td>
      </tr>
      <tr>
        <td id="L16" class="blob-num js-line-number" data-line-number="16"></td>
        <td id="LC16" class="blob-code blob-code-inner js-file-line">  txtvalue=<span class="pl-smi">$2</span></td>
      </tr>
      <tr>
        <td id="L17" class="blob-num js-line-number" data-line-number="17"></td>
        <td id="LC17" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L18" class="blob-num js-line-number" data-line-number="18"></td>
        <td id="LC18" class="blob-code blob-code-inner js-file-line">  GD_Key=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">${GD_Key<span class="pl-k">:-</span>$(_readaccountconf_mutable GD_Key)}</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L19" class="blob-num js-line-number" data-line-number="19"></td>
        <td id="LC19" class="blob-code blob-code-inner js-file-line">  GD_Secret=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">${GD_Secret<span class="pl-k">:-</span>$(_readaccountconf_mutable GD_Secret)}</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L20" class="blob-num js-line-number" data-line-number="20"></td>
        <td id="LC20" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> [ <span class="pl-k">-z</span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Key</span><span class="pl-pds">&quot;</span></span> ] <span class="pl-k">||</span> [ <span class="pl-k">-z</span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Secret</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L21" class="blob-num js-line-number" data-line-number="21"></td>
        <td id="LC21" class="blob-code blob-code-inner js-file-line">    GD_Key=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L22" class="blob-num js-line-number" data-line-number="22"></td>
        <td id="LC22" class="blob-code blob-code-inner js-file-line">    GD_Secret=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L23" class="blob-num js-line-number" data-line-number="23"></td>
        <td id="LC23" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>You don&#39;t specify godaddy api key and secret yet.<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L24" class="blob-num js-line-number" data-line-number="24"></td>
        <td id="LC24" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>Please create you key and try again.<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L25" class="blob-num js-line-number" data-line-number="25"></td>
        <td id="LC25" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L26" class="blob-num js-line-number" data-line-number="26"></td>
        <td id="LC26" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L27" class="blob-num js-line-number" data-line-number="27"></td>
        <td id="LC27" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L28" class="blob-num js-line-number" data-line-number="28"></td>
        <td id="LC28" class="blob-code blob-code-inner js-file-line">  <span class="pl-c"><span class="pl-c">#</span>save the api key and email to the account conf file.</span></td>
      </tr>
      <tr>
        <td id="L29" class="blob-num js-line-number" data-line-number="29"></td>
        <td id="LC29" class="blob-code blob-code-inner js-file-line">  _saveaccountconf_mutable GD_Key <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Key</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L30" class="blob-num js-line-number" data-line-number="30"></td>
        <td id="LC30" class="blob-code blob-code-inner js-file-line">  _saveaccountconf_mutable GD_Secret <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Secret</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L31" class="blob-num js-line-number" data-line-number="31"></td>
        <td id="LC31" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L32" class="blob-num js-line-number" data-line-number="32"></td>
        <td id="LC32" class="blob-code blob-code-inner js-file-line">  _debug <span class="pl-s"><span class="pl-pds">&quot;</span>First detect the root zone<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L33" class="blob-num js-line-number" data-line-number="33"></td>
        <td id="LC33" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> <span class="pl-k">!</span> _get_root <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$fulldomain</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L34" class="blob-num js-line-number" data-line-number="34"></td>
        <td id="LC34" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>invalid domain<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L35" class="blob-num js-line-number" data-line-number="35"></td>
        <td id="LC35" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L36" class="blob-num js-line-number" data-line-number="36"></td>
        <td id="LC36" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L37" class="blob-num js-line-number" data-line-number="37"></td>
        <td id="LC37" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L38" class="blob-num js-line-number" data-line-number="38"></td>
        <td id="LC38" class="blob-code blob-code-inner js-file-line">  _debug _sub_domain <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L39" class="blob-num js-line-number" data-line-number="39"></td>
        <td id="LC39" class="blob-code blob-code-inner js-file-line">  _debug _domain <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_domain</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L40" class="blob-num js-line-number" data-line-number="40"></td>
        <td id="LC40" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L41" class="blob-num js-line-number" data-line-number="41"></td>
        <td id="LC41" class="blob-code blob-code-inner js-file-line">  _debug <span class="pl-s"><span class="pl-pds">&quot;</span>Getting existing records<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L42" class="blob-num js-line-number" data-line-number="42"></td>
        <td id="LC42" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> <span class="pl-k">!</span> _gd_rest GET <span class="pl-s"><span class="pl-pds">&quot;</span>domains/<span class="pl-smi">$_domain</span>/records/TXT/<span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L43" class="blob-num js-line-number" data-line-number="43"></td>
        <td id="LC43" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L44" class="blob-num js-line-number" data-line-number="44"></td>
        <td id="LC44" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L45" class="blob-num js-line-number" data-line-number="45"></td>
        <td id="LC45" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L46" class="blob-num js-line-number" data-line-number="46"></td>
        <td id="LC46" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> _contains <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$txtvalue</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L47" class="blob-num js-line-number" data-line-number="47"></td>
        <td id="LC47" class="blob-code blob-code-inner js-file-line">    _info <span class="pl-s"><span class="pl-pds">&quot;</span>The record is existing, skip<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L48" class="blob-num js-line-number" data-line-number="48"></td>
        <td id="LC48" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 0</td>
      </tr>
      <tr>
        <td id="L49" class="blob-num js-line-number" data-line-number="49"></td>
        <td id="LC49" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L50" class="blob-num js-line-number" data-line-number="50"></td>
        <td id="LC50" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L51" class="blob-num js-line-number" data-line-number="51"></td>
        <td id="LC51" class="blob-code blob-code-inner js-file-line">  _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span>{<span class="pl-cce">\&quot;</span>data<span class="pl-cce">\&quot;</span>:<span class="pl-cce">\&quot;</span><span class="pl-smi">$txtvalue</span><span class="pl-cce">\&quot;</span>}<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L52" class="blob-num js-line-number" data-line-number="52"></td>
        <td id="LC52" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">for</span> <span class="pl-smi">t</span> <span class="pl-k">in</span> <span class="pl-s"><span class="pl-pds">$(</span>echo <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> tr <span class="pl-s"><span class="pl-pds">&#39;</span>{<span class="pl-pds">&#39;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>\n<span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> grep <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-cce">\&quot;</span>name<span class="pl-cce">\&quot;</span>:<span class="pl-cce">\&quot;</span><span class="pl-smi">$_sub_domain</span><span class="pl-cce">\&quot;</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> tr <span class="pl-s"><span class="pl-pds">&#39;</span>,<span class="pl-pds">&#39;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>\n<span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> grep <span class="pl-s"><span class="pl-pds">&#39;</span>&quot;data&quot;<span class="pl-pds">&#39;</span></span> <span class="pl-k">|</span> cut -d <span class="pl-c1">:</span> -f 2<span class="pl-pds">)</span></span><span class="pl-k">;</span> <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L53" class="blob-num js-line-number" data-line-number="53"></td>
        <td id="LC53" class="blob-code blob-code-inner js-file-line">    _debug2 t <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$t</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L54" class="blob-num js-line-number" data-line-number="54"></td>
        <td id="LC54" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$t</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L55" class="blob-num js-line-number" data-line-number="55"></td>
        <td id="LC55" class="blob-code blob-code-inner js-file-line">      _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span>,{<span class="pl-cce">\&quot;</span>data<span class="pl-cce">\&quot;</span>:<span class="pl-smi">$t</span>}<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L56" class="blob-num js-line-number" data-line-number="56"></td>
        <td id="LC56" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L57" class="blob-num js-line-number" data-line-number="57"></td>
        <td id="LC57" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">done</span></td>
      </tr>
      <tr>
        <td id="L58" class="blob-num js-line-number" data-line-number="58"></td>
        <td id="LC58" class="blob-code blob-code-inner js-file-line">  _debug2 _add_data <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L59" class="blob-num js-line-number" data-line-number="59"></td>
        <td id="LC59" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L60" class="blob-num js-line-number" data-line-number="60"></td>
        <td id="LC60" class="blob-code blob-code-inner js-file-line">  _info <span class="pl-s"><span class="pl-pds">&quot;</span>Adding record<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L61" class="blob-num js-line-number" data-line-number="61"></td>
        <td id="LC61" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> _gd_rest PUT <span class="pl-s"><span class="pl-pds">&quot;</span>domains/<span class="pl-smi">$_domain</span>/records/TXT/<span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>[<span class="pl-smi">$_add_data</span>]<span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L62" class="blob-num js-line-number" data-line-number="62"></td>
        <td id="LC62" class="blob-code blob-code-inner js-file-line">    _info <span class="pl-s"><span class="pl-pds">&quot;</span>Added, sleeping 10 seconds<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L63" class="blob-num js-line-number" data-line-number="63"></td>
        <td id="LC63" class="blob-code blob-code-inner js-file-line">    _sleep 10</td>
      </tr>
      <tr>
        <td id="L64" class="blob-num js-line-number" data-line-number="64"></td>
        <td id="LC64" class="blob-code blob-code-inner js-file-line">    <span class="pl-c"><span class="pl-c">#</span>todo: check if the record takes effect</span></td>
      </tr>
      <tr>
        <td id="L65" class="blob-num js-line-number" data-line-number="65"></td>
        <td id="LC65" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 0</td>
      </tr>
      <tr>
        <td id="L66" class="blob-num js-line-number" data-line-number="66"></td>
        <td id="LC66" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L67" class="blob-num js-line-number" data-line-number="67"></td>
        <td id="LC67" class="blob-code blob-code-inner js-file-line">  _err <span class="pl-s"><span class="pl-pds">&quot;</span>Add txt record error.<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L68" class="blob-num js-line-number" data-line-number="68"></td>
        <td id="LC68" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L69" class="blob-num js-line-number" data-line-number="69"></td>
        <td id="LC69" class="blob-code blob-code-inner js-file-line">}</td>
      </tr>
      <tr>
        <td id="L70" class="blob-num js-line-number" data-line-number="70"></td>
        <td id="LC70" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L71" class="blob-num js-line-number" data-line-number="71"></td>
        <td id="LC71" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>fulldomain</span></td>
      </tr>
      <tr>
        <td id="L72" class="blob-num js-line-number" data-line-number="72"></td>
        <td id="LC72" class="blob-code blob-code-inner js-file-line"><span class="pl-en">dns_gd_rm</span>() {</td>
      </tr>
      <tr>
        <td id="L73" class="blob-num js-line-number" data-line-number="73"></td>
        <td id="LC73" class="blob-code blob-code-inner js-file-line">  fulldomain=<span class="pl-smi">$1</span></td>
      </tr>
      <tr>
        <td id="L74" class="blob-num js-line-number" data-line-number="74"></td>
        <td id="LC74" class="blob-code blob-code-inner js-file-line">  txtvalue=<span class="pl-smi">$2</span></td>
      </tr>
      <tr>
        <td id="L75" class="blob-num js-line-number" data-line-number="75"></td>
        <td id="LC75" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L76" class="blob-num js-line-number" data-line-number="76"></td>
        <td id="LC76" class="blob-code blob-code-inner js-file-line">  GD_Key=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">${GD_Key<span class="pl-k">:-</span>$(_readaccountconf_mutable GD_Key)}</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L77" class="blob-num js-line-number" data-line-number="77"></td>
        <td id="LC77" class="blob-code blob-code-inner js-file-line">  GD_Secret=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">${GD_Secret<span class="pl-k">:-</span>$(_readaccountconf_mutable GD_Secret)}</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L78" class="blob-num js-line-number" data-line-number="78"></td>
        <td id="LC78" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L79" class="blob-num js-line-number" data-line-number="79"></td>
        <td id="LC79" class="blob-code blob-code-inner js-file-line">  _debug <span class="pl-s"><span class="pl-pds">&quot;</span>First detect the root zone<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L80" class="blob-num js-line-number" data-line-number="80"></td>
        <td id="LC80" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> <span class="pl-k">!</span> _get_root <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$fulldomain</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L81" class="blob-num js-line-number" data-line-number="81"></td>
        <td id="LC81" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>invalid domain<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L82" class="blob-num js-line-number" data-line-number="82"></td>
        <td id="LC82" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L83" class="blob-num js-line-number" data-line-number="83"></td>
        <td id="LC83" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L84" class="blob-num js-line-number" data-line-number="84"></td>
        <td id="LC84" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L85" class="blob-num js-line-number" data-line-number="85"></td>
        <td id="LC85" class="blob-code blob-code-inner js-file-line">  _debug _sub_domain <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L86" class="blob-num js-line-number" data-line-number="86"></td>
        <td id="LC86" class="blob-code blob-code-inner js-file-line">  _debug _domain <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_domain</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L87" class="blob-num js-line-number" data-line-number="87"></td>
        <td id="LC87" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L88" class="blob-num js-line-number" data-line-number="88"></td>
        <td id="LC88" class="blob-code blob-code-inner js-file-line">  _debug <span class="pl-s"><span class="pl-pds">&quot;</span>Getting existing records<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L89" class="blob-num js-line-number" data-line-number="89"></td>
        <td id="LC89" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> <span class="pl-k">!</span> _gd_rest GET <span class="pl-s"><span class="pl-pds">&quot;</span>domains/<span class="pl-smi">$_domain</span>/records/TXT/<span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L90" class="blob-num js-line-number" data-line-number="90"></td>
        <td id="LC90" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L91" class="blob-num js-line-number" data-line-number="91"></td>
        <td id="LC91" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L92" class="blob-num js-line-number" data-line-number="92"></td>
        <td id="LC92" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L93" class="blob-num js-line-number" data-line-number="93"></td>
        <td id="LC93" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> <span class="pl-k">!</span> _contains <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$txtvalue</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L94" class="blob-num js-line-number" data-line-number="94"></td>
        <td id="LC94" class="blob-code blob-code-inner js-file-line">    _info <span class="pl-s"><span class="pl-pds">&quot;</span>The record is not existing, skip<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L95" class="blob-num js-line-number" data-line-number="95"></td>
        <td id="LC95" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 0</td>
      </tr>
      <tr>
        <td id="L96" class="blob-num js-line-number" data-line-number="96"></td>
        <td id="LC96" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L97" class="blob-num js-line-number" data-line-number="97"></td>
        <td id="LC97" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L98" class="blob-num js-line-number" data-line-number="98"></td>
        <td id="LC98" class="blob-code blob-code-inner js-file-line">  _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L99" class="blob-num js-line-number" data-line-number="99"></td>
        <td id="LC99" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">for</span> <span class="pl-smi">t</span> <span class="pl-k">in</span> <span class="pl-s"><span class="pl-pds">$(</span>echo <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> tr <span class="pl-s"><span class="pl-pds">&#39;</span>{<span class="pl-pds">&#39;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>\n<span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> grep <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-cce">\&quot;</span>name<span class="pl-cce">\&quot;</span>:<span class="pl-cce">\&quot;</span><span class="pl-smi">$_sub_domain</span><span class="pl-cce">\&quot;</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> tr <span class="pl-s"><span class="pl-pds">&#39;</span>,<span class="pl-pds">&#39;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>\n<span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> grep <span class="pl-s"><span class="pl-pds">&#39;</span>&quot;data&quot;<span class="pl-pds">&#39;</span></span> <span class="pl-k">|</span> cut -d <span class="pl-c1">:</span> -f 2<span class="pl-pds">)</span></span><span class="pl-k">;</span> <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L100" class="blob-num js-line-number" data-line-number="100"></td>
        <td id="LC100" class="blob-code blob-code-inner js-file-line">    _debug2 t <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$t</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L101" class="blob-num js-line-number" data-line-number="101"></td>
        <td id="LC101" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$t</span><span class="pl-pds">&quot;</span></span> ] <span class="pl-k">&amp;&amp;</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$t</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">!=</span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-cce">\&quot;</span><span class="pl-smi">$txtvalue</span><span class="pl-cce">\&quot;</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L102" class="blob-num js-line-number" data-line-number="102"></td>
        <td id="LC102" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">if</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L103" class="blob-num js-line-number" data-line-number="103"></td>
        <td id="LC103" class="blob-code blob-code-inner js-file-line">        _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span>,{<span class="pl-cce">\&quot;</span>data<span class="pl-cce">\&quot;</span>:<span class="pl-smi">$t</span>}<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L104" class="blob-num js-line-number" data-line-number="104"></td>
        <td id="LC104" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L105" class="blob-num js-line-number" data-line-number="105"></td>
        <td id="LC105" class="blob-code blob-code-inner js-file-line">        _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span>{<span class="pl-cce">\&quot;</span>data<span class="pl-cce">\&quot;</span>:<span class="pl-smi">$t</span>}<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L106" class="blob-num js-line-number" data-line-number="106"></td>
        <td id="LC106" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L107" class="blob-num js-line-number" data-line-number="107"></td>
        <td id="LC107" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L108" class="blob-num js-line-number" data-line-number="108"></td>
        <td id="LC108" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">done</span></td>
      </tr>
      <tr>
        <td id="L109" class="blob-num js-line-number" data-line-number="109"></td>
        <td id="LC109" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> [ <span class="pl-k">-z</span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L110" class="blob-num js-line-number" data-line-number="110"></td>
        <td id="LC110" class="blob-code blob-code-inner js-file-line">    _add_data=<span class="pl-s"><span class="pl-pds">&quot;</span>{<span class="pl-cce">\&quot;</span>data<span class="pl-cce">\&quot;</span>:<span class="pl-cce">\&quot;\&quot;</span>}<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L111" class="blob-num js-line-number" data-line-number="111"></td>
        <td id="LC111" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L112" class="blob-num js-line-number" data-line-number="112"></td>
        <td id="LC112" class="blob-code blob-code-inner js-file-line">  _debug2 _add_data <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$_add_data</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L113" class="blob-num js-line-number" data-line-number="113"></td>
        <td id="LC113" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L114" class="blob-num js-line-number" data-line-number="114"></td>
        <td id="LC114" class="blob-code blob-code-inner js-file-line">  _gd_rest PUT <span class="pl-s"><span class="pl-pds">&quot;</span>domains/<span class="pl-smi">$_domain</span>/records/TXT/<span class="pl-smi">$_sub_domain</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>[<span class="pl-smi">$_add_data</span>]<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L115" class="blob-num js-line-number" data-line-number="115"></td>
        <td id="LC115" class="blob-code blob-code-inner js-file-line">}</td>
      </tr>
      <tr>
        <td id="L116" class="blob-num js-line-number" data-line-number="116"></td>
        <td id="LC116" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L117" class="blob-num js-line-number" data-line-number="117"></td>
        <td id="LC117" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>###################  Private functions below ##################################</span></td>
      </tr>
      <tr>
        <td id="L118" class="blob-num js-line-number" data-line-number="118"></td>
        <td id="LC118" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>_acme-challenge.www.domain.com</span></td>
      </tr>
      <tr>
        <td id="L119" class="blob-num js-line-number" data-line-number="119"></td>
        <td id="LC119" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span>returns</span></td>
      </tr>
      <tr>
        <td id="L120" class="blob-num js-line-number" data-line-number="120"></td>
        <td id="LC120" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span> _sub_domain=_acme-challenge.www</span></td>
      </tr>
      <tr>
        <td id="L121" class="blob-num js-line-number" data-line-number="121"></td>
        <td id="LC121" class="blob-code blob-code-inner js-file-line"><span class="pl-c"><span class="pl-c">#</span> _domain=domain.com</span></td>
      </tr>
      <tr>
        <td id="L122" class="blob-num js-line-number" data-line-number="122"></td>
        <td id="LC122" class="blob-code blob-code-inner js-file-line"><span class="pl-en">_get_root</span>() {</td>
      </tr>
      <tr>
        <td id="L123" class="blob-num js-line-number" data-line-number="123"></td>
        <td id="LC123" class="blob-code blob-code-inner js-file-line">  domain=<span class="pl-smi">$1</span></td>
      </tr>
      <tr>
        <td id="L124" class="blob-num js-line-number" data-line-number="124"></td>
        <td id="LC124" class="blob-code blob-code-inner js-file-line">  i=2</td>
      </tr>
      <tr>
        <td id="L125" class="blob-num js-line-number" data-line-number="125"></td>
        <td id="LC125" class="blob-code blob-code-inner js-file-line">  p=1</td>
      </tr>
      <tr>
        <td id="L126" class="blob-num js-line-number" data-line-number="126"></td>
        <td id="LC126" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">while</span> <span class="pl-c1">true</span><span class="pl-k">;</span> <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L127" class="blob-num js-line-number" data-line-number="127"></td>
        <td id="LC127" class="blob-code blob-code-inner js-file-line">    h=<span class="pl-s"><span class="pl-pds">$(</span>printf <span class="pl-s"><span class="pl-pds">&quot;</span>%s<span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$domain</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> cut -d <span class="pl-c1">.</span> -f <span class="pl-smi">$i</span>-100<span class="pl-pds">)</span></span></td>
      </tr>
      <tr>
        <td id="L128" class="blob-num js-line-number" data-line-number="128"></td>
        <td id="LC128" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> [ <span class="pl-k">-z</span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$h</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L129" class="blob-num js-line-number" data-line-number="129"></td>
        <td id="LC129" class="blob-code blob-code-inner js-file-line">      <span class="pl-c"><span class="pl-c">#</span>not valid</span></td>
      </tr>
      <tr>
        <td id="L130" class="blob-num js-line-number" data-line-number="130"></td>
        <td id="LC130" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L131" class="blob-num js-line-number" data-line-number="131"></td>
        <td id="LC131" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L132" class="blob-num js-line-number" data-line-number="132"></td>
        <td id="LC132" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L133" class="blob-num js-line-number" data-line-number="133"></td>
        <td id="LC133" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> <span class="pl-k">!</span> _gd_rest GET <span class="pl-s"><span class="pl-pds">&quot;</span>domains/<span class="pl-smi">$h</span><span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L134" class="blob-num js-line-number" data-line-number="134"></td>
        <td id="LC134" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L135" class="blob-num js-line-number" data-line-number="135"></td>
        <td id="LC135" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L136" class="blob-num js-line-number" data-line-number="136"></td>
        <td id="LC136" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L137" class="blob-num js-line-number" data-line-number="137"></td>
        <td id="LC137" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">if</span> _contains <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&#39;</span>&quot;code&quot;:&quot;NOT_FOUND&quot;<span class="pl-pds">&#39;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L138" class="blob-num js-line-number" data-line-number="138"></td>
        <td id="LC138" class="blob-code blob-code-inner js-file-line">      _debug <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$h</span> not found<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L139" class="blob-num js-line-number" data-line-number="139"></td>
        <td id="LC139" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L140" class="blob-num js-line-number" data-line-number="140"></td>
        <td id="LC140" class="blob-code blob-code-inner js-file-line">      _sub_domain=<span class="pl-s"><span class="pl-pds">$(</span>printf <span class="pl-s"><span class="pl-pds">&quot;</span>%s<span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$domain</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">|</span> cut -d <span class="pl-c1">.</span> -f 1-<span class="pl-smi">$p</span><span class="pl-pds">)</span></span></td>
      </tr>
      <tr>
        <td id="L141" class="blob-num js-line-number" data-line-number="141"></td>
        <td id="LC141" class="blob-code blob-code-inner js-file-line">      _domain=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$h</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L142" class="blob-num js-line-number" data-line-number="142"></td>
        <td id="LC142" class="blob-code blob-code-inner js-file-line">      <span class="pl-k">return</span> 0</td>
      </tr>
      <tr>
        <td id="L143" class="blob-num js-line-number" data-line-number="143"></td>
        <td id="LC143" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L144" class="blob-num js-line-number" data-line-number="144"></td>
        <td id="LC144" class="blob-code blob-code-inner js-file-line">    p=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$i</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L145" class="blob-num js-line-number" data-line-number="145"></td>
        <td id="LC145" class="blob-code blob-code-inner js-file-line">    i=<span class="pl-s"><span class="pl-pds">$(</span>_math <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$i</span><span class="pl-pds">&quot;</span></span> + 1<span class="pl-pds">)</span></span></td>
      </tr>
      <tr>
        <td id="L146" class="blob-num js-line-number" data-line-number="146"></td>
        <td id="LC146" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">done</span></td>
      </tr>
      <tr>
        <td id="L147" class="blob-num js-line-number" data-line-number="147"></td>
        <td id="LC147" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L148" class="blob-num js-line-number" data-line-number="148"></td>
        <td id="LC148" class="blob-code blob-code-inner js-file-line">}</td>
      </tr>
      <tr>
        <td id="L149" class="blob-num js-line-number" data-line-number="149"></td>
        <td id="LC149" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L150" class="blob-num js-line-number" data-line-number="150"></td>
        <td id="LC150" class="blob-code blob-code-inner js-file-line"><span class="pl-en">_gd_rest</span>() {</td>
      </tr>
      <tr>
        <td id="L151" class="blob-num js-line-number" data-line-number="151"></td>
        <td id="LC151" class="blob-code blob-code-inner js-file-line">  m=<span class="pl-smi">$1</span></td>
      </tr>
      <tr>
        <td id="L152" class="blob-num js-line-number" data-line-number="152"></td>
        <td id="LC152" class="blob-code blob-code-inner js-file-line">  ep=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$2</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L153" class="blob-num js-line-number" data-line-number="153"></td>
        <td id="LC153" class="blob-code blob-code-inner js-file-line">  data=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$3</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L154" class="blob-num js-line-number" data-line-number="154"></td>
        <td id="LC154" class="blob-code blob-code-inner js-file-line">  _debug <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$ep</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L155" class="blob-num js-line-number" data-line-number="155"></td>
        <td id="LC155" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L156" class="blob-num js-line-number" data-line-number="156"></td>
        <td id="LC156" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">export</span> _H1=<span class="pl-s"><span class="pl-pds">&quot;</span>Authorization: sso-key <span class="pl-smi">$GD_Key</span>:<span class="pl-smi">$GD_Secret</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L157" class="blob-num js-line-number" data-line-number="157"></td>
        <td id="LC157" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">export</span> _H2=<span class="pl-s"><span class="pl-pds">&quot;</span>Content-Type: application/json<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L158" class="blob-num js-line-number" data-line-number="158"></td>
        <td id="LC158" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L159" class="blob-num js-line-number" data-line-number="159"></td>
        <td id="LC159" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$data</span><span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L160" class="blob-num js-line-number" data-line-number="160"></td>
        <td id="LC160" class="blob-code blob-code-inner js-file-line">    _debug data <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$data</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L161" class="blob-num js-line-number" data-line-number="161"></td>
        <td id="LC161" class="blob-code blob-code-inner js-file-line">    response=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-s"><span class="pl-pds">$(</span>_post <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$data</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Api</span>/<span class="pl-smi">$ep</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$m</span><span class="pl-pds">&quot;</span></span><span class="pl-pds">)</span></span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L162" class="blob-num js-line-number" data-line-number="162"></td>
        <td id="LC162" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L163" class="blob-num js-line-number" data-line-number="163"></td>
        <td id="LC163" class="blob-code blob-code-inner js-file-line">    response=<span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-s"><span class="pl-pds">$(</span>_get <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$GD_Api</span>/<span class="pl-smi">$ep</span><span class="pl-pds">&quot;</span></span><span class="pl-pds">)</span></span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L164" class="blob-num js-line-number" data-line-number="164"></td>
        <td id="LC164" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L165" class="blob-num js-line-number" data-line-number="165"></td>
        <td id="LC165" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L166" class="blob-num js-line-number" data-line-number="166"></td>
        <td id="LC166" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> [ <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$?</span><span class="pl-pds">&quot;</span></span> <span class="pl-k">!=</span> <span class="pl-s"><span class="pl-pds">&quot;</span>0<span class="pl-pds">&quot;</span></span> ]<span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L167" class="blob-num js-line-number" data-line-number="167"></td>
        <td id="LC167" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>error <span class="pl-smi">$ep</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L168" class="blob-num js-line-number" data-line-number="168"></td>
        <td id="LC168" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L169" class="blob-num js-line-number" data-line-number="169"></td>
        <td id="LC169" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L170" class="blob-num js-line-number" data-line-number="170"></td>
        <td id="LC170" class="blob-code blob-code-inner js-file-line">  _debug2 response <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L171" class="blob-num js-line-number" data-line-number="171"></td>
        <td id="LC171" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">if</span> _contains <span class="pl-s"><span class="pl-pds">&quot;</span><span class="pl-smi">$response</span><span class="pl-pds">&quot;</span></span> <span class="pl-s"><span class="pl-pds">&quot;</span>UNABLE_TO_AUTHENTICATE<span class="pl-pds">&quot;</span></span><span class="pl-k">;</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L172" class="blob-num js-line-number" data-line-number="172"></td>
        <td id="LC172" class="blob-code blob-code-inner js-file-line">    _err <span class="pl-s"><span class="pl-pds">&quot;</span>It seems that your api key or secret is not correct.<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L173" class="blob-num js-line-number" data-line-number="173"></td>
        <td id="LC173" class="blob-code blob-code-inner js-file-line">    <span class="pl-k">return</span> 1</td>
      </tr>
      <tr>
        <td id="L174" class="blob-num js-line-number" data-line-number="174"></td>
        <td id="LC174" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">fi</span></td>
      </tr>
      <tr>
        <td id="L175" class="blob-num js-line-number" data-line-number="175"></td>
        <td id="LC175" class="blob-code blob-code-inner js-file-line">  <span class="pl-k">return</span> 0</td>
      </tr>
      <tr>
        <td id="L176" class="blob-num js-line-number" data-line-number="176"></td>
        <td id="LC176" class="blob-code blob-code-inner js-file-line">}</td>
      </tr>
</table>

  <details class="details-reset details-overlay BlobToolbar position-absolute js-file-line-actions dropdown d-none" aria-hidden="true">
    <summary class="btn-octicon ml-0 px-2 p-0 bg-white border border-gray-dark rounded-1" aria-label="Inline file action toolbar">
      <svg class="octicon octicon-kebab-horizontal" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="M8 9C8.82843 9 9.5 8.32843 9.5 7.5C9.5 6.67157 8.82843 6 8 6C7.17157 6 6.5 6.67157 6.5 7.5C6.5 8.32843 7.17157 9 8 9Z"></path>
  <path d="M1.5 9C2.32843 9 3 8.32843 3 7.5C3 6.67157 2.32843 6 1.5 6C0.671573 6 0 6.67157 0 7.5C0 8.32843 0.671573 9 1.5 9Z"></path>
  <path d="M14.5 9C15.3284 9 16 8.32843 16 7.5C16 6.67157 15.3284 6 14.5 6C13.6716 6 13 6.67157 13 7.5C13 8.32843 13.6716 9 14.5 9Z"></path></svg>
    </summary>
    <details-menu>
      <ul class="BlobToolbar-dropdown dropdown-menu dropdown-menu-se mt-2" style="width:185px">
        <li>
          <clipboard-copy role="menuitem" class="dropdown-item" id="js-copy-lines" style="cursor:pointer;">
            Copy lines
          </clipboard-copy>
        </li>
        <li>
          <clipboard-copy role="menuitem" class="dropdown-item" id="js-copy-permalink" style="cursor:pointer;">
            Copy permalink
          </clipboard-copy>
        </li>
        <li><a class="dropdown-item js-update-url-with-hash" id="js-view-git-blame" role="menuitem" href="/acmesh-official/acme.sh/blame/9190fdd42c5332f8821ce3f0de91cf0d18fa07d5/dnsapi/dns_gd.sh">View git blame</a></li>
          <li><a class="dropdown-item" id="js-new-issue" role="menuitem" href="/acmesh-official/acme.sh/issues/new">Reference in new issue</a></li>
      </ul>
    </details-menu>
  </details>

  </div>

    </div>

  

  <details class="details-reset details-overlay details-overlay-dark">
    <summary data-hotkey="l" aria-label="Jump to line"></summary>
    <details-dialog class="Box Box--overlay d-flex flex-column anim-fade-in fast linejump" aria-label="Jump to line">
      <!-- '"` --><!-- </textarea></xmp> --></option></form><form class="js-jump-to-line-form Box-body d-flex" action="" accept-charset="UTF-8" method="get">
        <input class="form-control flex-auto mr-3 linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" aria-label="Jump to line" autofocus>
        <button type="submit" class="btn" data-close-dialog>Go</button>
</form>    </details-dialog>
  </details>



  </div>
</div>

    </main>
  </div>
  

  </div>

        
<div class="footer container-lg width-full p-responsive" role="contentinfo">
  <div class="position-relative d-flex flex-row-reverse flex-lg-row flex-wrap flex-lg-nowrap flex-justify-center flex-lg-justify-between pt-6 pb-2 mt-6 f6 text-gray border-top border-gray-light ">
    <ul class="list-style-none d-flex flex-wrap col-12 col-lg-5 flex-justify-center flex-lg-justify-between mb-2 mb-lg-0">
      <li class="mr-3 mr-lg-0">&copy; 2020 GitHub, Inc.</li>
        <li class="mr-3 mr-lg-0"><a data-ga-click="Footer, go to terms, text:terms" href="https://github.com/site/terms">Terms</a></li>
        <li class="mr-3 mr-lg-0"><a data-ga-click="Footer, go to privacy, text:privacy" href="https://github.com/site/privacy">Privacy</a></li>
        <li class="mr-3 mr-lg-0"><a data-ga-click="Footer, go to security, text:security" href="https://github.com/security">Security</a></li>
        <li class="mr-3 mr-lg-0"><a href="https://githubstatus.com/" data-ga-click="Footer, go to status, text:status">Status</a></li>
        <li><a data-ga-click="Footer, go to help, text:help" href="https://help.github.com">Help</a></li>

    </ul>

    <a aria-label="Homepage" title="GitHub" class="footer-octicon d-none d-lg-block mx-lg-4" href="https://github.com">
      <svg height="24" class="octicon octicon-mark-github" viewBox="0 0 16 16" version="1.1" width="24" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8C0 11.54 2.29 14.53 5.47 15.59C5.87 15.66 6.02 15.42 6.02 15.21C6.02 15.02 6.01 14.39 6.01 13.72C4 14.09 3.48 13.23 3.32 12.78C3.23 12.55 2.84 11.84 2.5 11.65C2.22 11.5 1.82 11.13 2.49 11.12C3.12 11.11 3.57 11.7 3.72 11.94C4.44 13.15 5.59 12.81 6.05 12.6C6.12 12.08 6.33 11.73 6.56 11.53C4.78 11.33 2.92 10.64 2.92 7.58C2.92 6.71 3.23 5.99 3.74 5.43C3.66 5.23 3.38 4.41 3.82 3.31C3.82 3.31 4.49 3.1 6.02 4.13C6.66 3.95 7.34 3.86 8.02 3.86C8.7 3.86 9.38 3.95 10.02 4.13C11.55 3.09 12.22 3.31 12.22 3.31C12.66 4.41 12.38 5.23 12.3 5.43C12.81 5.99 13.12 6.7 13.12 7.58C13.12 10.65 11.25 11.33 9.47 11.53C9.76 11.78 10.01 12.26 10.01 13.01C10.01 14.08 10 14.94 10 15.21C10 15.42 10.15 15.67 10.55 15.59C13.71 14.53 16 11.53 16 8C16 3.58 12.42 0 8 0Z"></path></svg>
</a>
   <ul class="list-style-none d-flex flex-wrap col-12 col-lg-5 flex-justify-center flex-lg-justify-between mb-2 mb-lg-0">
        <li class="mr-3 mr-lg-0"><a data-ga-click="Footer, go to contact, text:contact" href="https://github.com/contact">Contact GitHub</a></li>
        <li class="mr-3 mr-lg-0"><a href="https://github.com/pricing" data-ga-click="Footer, go to Pricing, text:Pricing">Pricing</a></li>
      <li class="mr-3 mr-lg-0"><a href="https://developer.github.com" data-ga-click="Footer, go to api, text:api">API</a></li>
      <li class="mr-3 mr-lg-0"><a href="https://training.github.com" data-ga-click="Footer, go to training, text:training">Training</a></li>
        <li class="mr-3 mr-lg-0"><a href="https://github.blog" data-ga-click="Footer, go to blog, text:blog">Blog</a></li>
        <li><a data-ga-click="Footer, go to about, text:about" href="https://github.com/about">About</a></li>
    </ul>
  </div>
  <div class="d-flex flex-justify-center pb-6">
    <span class="f6 text-gray-light"></span>
  </div>
</div>



  <div id="ajax-error-message" class="ajax-error-message flash flash-error">
    <svg class="octicon octicon-alert" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.22048 1.75358C8.1263 1.57738 7.87369 1.57738 7.77951 1.75359L1.69787 13.1321C1.60886 13.2987 1.72953 13.5 1.91835 13.5H14.0816C14.2705 13.5 14.3911 13.2987 14.3021 13.1321L8.22048 1.75358ZM6.45662 1.04652C7.11588 -0.186933 8.88412 -0.186935 9.54338 1.04652L15.625 12.4251C16.2481 13.5908 15.4034 15 14.0816 15H1.91835C0.596554 15 -0.248093 13.5908 0.374974 12.4251L6.45662 1.04652ZM9 11C9 11.5523 8.55229 12 8 12C7.44772 12 7 11.5523 7 11C7 10.4477 7.44772 10 8 10C8.55229 10 9 10.4477 9 11ZM8.75 5.75C8.75 5.33579 8.41421 5 8 5C7.58579 5 7.25 5.33579 7.25 5.75V8.25C7.25 8.66421 7.58579 9 8 9C8.41421 9 8.75 8.66421 8.75 8.25V5.75Z"></path></svg>
    <button type="button" class="flash-close js-ajax-error-dismiss" aria-label="Dismiss error">
      <svg class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>
    </button>
    You can’t perform that action at this time.
  </div>


    <script crossorigin="anonymous" async="async" integrity="sha512-WcQmT2vhcClFVOaaAJV/M+HqsJ2Gq/myvl6F3gCVBxykazXTs+i5fvxncSXwyG1CSfcrqmLFw/R/bmFYzprX2A==" type="application/javascript" id="js-conditional-compat" data-src="https://github.githubassets.com/assets/compat-bootstrap-59c4264f.js"></script>
    <script crossorigin="anonymous" integrity="sha512-Y86V8OBlvF6I/7e56GKOOt80Yg1RTGA09uqFFX18aiBtevLbKGxB7sVpCn79fukppFIBqyBTB/s6l0Bhn0kidQ==" type="application/javascript" src="https://github.githubassets.com/assets/environment-bootstrap-63ce95f0.js"></script>
    <script crossorigin="anonymous" async="async" integrity="sha512-W/Z2I9q6YKINknRzZ2Zzw02d+fK1asPVyLiNEfmQ+16M7dKnjghpXCTWTZDONLw3Wa1cU68eEFnJex44Wyj/og==" type="application/javascript" src="https://github.githubassets.com/assets/vendor-5bf67623.js"></script>
    <script crossorigin="anonymous" async="async" integrity="sha512-kuQtl2H1vsQQzQYmzfNRDKBKnqomjaKNZQmGwS6OrUkrvClS2RVeKyy3B88Psl0kaEq+wwaKEf9RbAsNHO7YOw==" type="application/javascript" src="https://github.githubassets.com/assets/frameworks-92e42d97.js"></script>
    
    <script crossorigin="anonymous" async="async" integrity="sha512-5CkBpZbYBks/pmGcGjurqVBKdv9PvR7D65HqMwQywMFbZZXqPmbwrxSZUjx9JO/yi+YllEAMEg6fXlTuw/vaQQ==" type="application/javascript" src="https://github.githubassets.com/assets/github-bootstrap-e42901a5.js"></script>
    
        <script crossorigin="anonymous" async="async" integrity="sha512-4GcSWGoe36+BoWho4gtJcByZe8j43w+lt2/PDe3rmBxRVSgD29YipDwuIywe8fvOd2b2CszBqaPGxSznUtE3Xg==" type="application/javascript" data-module-id="./drag-drop.js" data-src="https://github.githubassets.com/assets/drag-drop-e0671258.js"></script>
        <script crossorigin="anonymous" async="async" integrity="sha512-3Vk1NFIOm+TBUMM6pTA6DCUwwLLnc/QIT8jpENm71InvSU8O4p2plDagpst1tH1l+9jOBnneaXZnAskA9a2b3w==" type="application/javascript" data-module-id="./gist-vendor.js" data-src="https://github.githubassets.com/assets/gist-vendor-dd593534.js"></script>
        <script crossorigin="anonymous" async="async" integrity="sha512-urN6bhHnHu4C12A+cTH3dOp+CwLaycy2HUXr95hvu5pbYRdF8z6iR+UQcTZutQ6mZG3Njluw2MTZVCNmwcqh8g==" type="application/javascript" data-module-id="./randomColor.js" data-src="https://github.githubassets.com/assets/randomColor-bab37a6e.js"></script>
    
    
  <div class="js-stale-session-flash flash flash-warn flash-banner" hidden
    >
    <svg class="octicon octicon-alert" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.22048 1.75358C8.1263 1.57738 7.87369 1.57738 7.77951 1.75359L1.69787 13.1321C1.60886 13.2987 1.72953 13.5 1.91835 13.5H14.0816C14.2705 13.5 14.3911 13.2987 14.3021 13.1321L8.22048 1.75358ZM6.45662 1.04652C7.11588 -0.186933 8.88412 -0.186935 9.54338 1.04652L15.625 12.4251C16.2481 13.5908 15.4034 15 14.0816 15H1.91835C0.596554 15 -0.248093 13.5908 0.374974 12.4251L6.45662 1.04652ZM9 11C9 11.5523 8.55229 12 8 12C7.44772 12 7 11.5523 7 11C7 10.4477 7.44772 10 8 10C8.55229 10 9 10.4477 9 11ZM8.75 5.75C8.75 5.33579 8.41421 5 8 5C7.58579 5 7.25 5.33579 7.25 5.75V8.25C7.25 8.66421 7.58579 9 8 9C8.41421 9 8.75 8.66421 8.75 8.25V5.75Z"></path></svg>
    <span class="js-stale-session-flash-signed-in" hidden>You signed in with another tab or window. <a href="">Reload</a> to refresh your session.</span>
    <span class="js-stale-session-flash-signed-out" hidden>You signed out in another tab or window. <a href="">Reload</a> to refresh your session.</span>
  </div>
  <template id="site-details-dialog">
  <details class="details-reset details-overlay details-overlay-dark lh-default text-gray-dark hx_rsm" open>
    <summary role="button" aria-label="Close dialog"></summary>
    <details-dialog class="Box Box--overlay d-flex flex-column anim-fade-in fast hx_rsm-dialog hx_rsm-modal">
      <button class="Box-btn-octicon m-0 btn-octicon position-absolute right-0 top-0" type="button" aria-label="Close dialog" data-close-dialog>
        <svg class="octicon octicon-x" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.72 3.72C3.86062 3.57955 4.05125 3.50066 4.25 3.50066C4.44875 3.50066 4.63937 3.57955 4.78 3.72L8 6.94L11.22 3.72C11.2887 3.64631 11.3715 3.58721 11.4635 3.54622C11.5555 3.50523 11.6548 3.48319 11.7555 3.48141C11.8562 3.47963 11.9562 3.49816 12.0496 3.53588C12.143 3.5736 12.2278 3.62974 12.299 3.70096C12.3703 3.77218 12.4264 3.85702 12.4641 3.9504C12.5018 4.04379 12.5204 4.14382 12.5186 4.24452C12.5168 4.34523 12.4948 4.44454 12.4538 4.53654C12.4128 4.62854 12.3537 4.71134 12.28 4.78L9.06 8L12.28 11.22C12.3537 11.2887 12.4128 11.3715 12.4538 11.4635C12.4948 11.5555 12.5168 11.6548 12.5186 11.7555C12.5204 11.8562 12.5018 11.9562 12.4641 12.0496C12.4264 12.143 12.3703 12.2278 12.299 12.299C12.2278 12.3703 12.143 12.4264 12.0496 12.4641C11.9562 12.5018 11.8562 12.5204 11.7555 12.5186C11.6548 12.5168 11.5555 12.4948 11.4635 12.4538C11.3715 12.4128 11.2887 12.3537 11.22 12.28L8 9.06L4.78 12.28C4.63782 12.4125 4.44977 12.4846 4.25547 12.4812C4.06117 12.4777 3.87579 12.399 3.73837 12.2616C3.60096 12.1242 3.52225 11.9388 3.51882 11.7445C3.51539 11.5502 3.58752 11.3622 3.72 11.22L6.94 8L3.72 4.78C3.57955 4.63938 3.50066 4.44875 3.50066 4.25C3.50066 4.05125 3.57955 3.86063 3.72 3.72Z"></path></svg>
      </button>
      <div class="octocat-spinner my-6 js-details-dialog-spinner"></div>
    </details-dialog>
  </details>
</template>

  <div class="Popover js-hovercard-content position-absolute" style="display: none; outline: none;" tabindex="0">
  <div class="Popover-message Popover-message--bottom-left Popover-message--large Box box-shadow-large" style="width:360px;">
  </div>
</div>


  </body>
</html>

