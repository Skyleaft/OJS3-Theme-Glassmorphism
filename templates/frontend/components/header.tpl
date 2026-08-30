{**
 * @file templates/frontend/components/header.tpl
 *
 * Glass Theme — Sticky glassmorphism navigation header
 *}
{capture assign="initialTheme"}{if $colorMode == 'light'}light{elseif $colorMode == 'dark'}dark{else}auto{/if}{/capture}
<!DOCTYPE html>
<html data-theme="dark" lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<script>
    (function() {
        try {
            const STORAGE_KEY = 'glass-theme-color-mode';
            const setting = '{$initialTheme}';
            let theme = localStorage.getItem(STORAGE_KEY);
            
            if (!theme || theme === 'auto') {
                if (setting === 'auto') {
                    theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
                } else {
                    theme = setting;
                }
            }
            
            document.documentElement.setAttribute('data-theme', theme);
            if (theme === 'light') document.documentElement.classList.add('theme-light');
            else document.documentElement.classList.remove('theme-light');
        } catch (e) {}
    })();
</script>
<script src="{$baseUrl}/plugins/themes/glassTheme/js/glass-theme.js" defer></script>
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}" dir="{if $currentLocale|substr:0:2 == 'ar'}rtl{else}ltr{/if}">

    {* Skip-to-content for accessibility *}
    <a id="skip-to-content" class="sr-only" href="#main-content">
        {translate key="plugins.themes.glassTheme.skipToContent"}
    </a>

    {* Get ISSN data for display *}
    {assign var="onlineIssn" value=$currentJournal->getData('onlineIssn')}
    {assign var="printIssn" value=$currentJournal->getData('printIssn')}
    {assign var="journalAcronym" value=$currentJournal->getLocalizedAcronym()}
    {assign var="publisherInst" value=$currentJournal->getData('publisherInstitution')}

    {* ═══════════════════════════════════════════════════════════════════════════
       LAYER 1: TOP BAR (Announcement, Open Access Badge, ISSN, Theme & Locale)
       ═══════════════════════════════════════════════════════════════════════════ *}
    <div class="glass-topbar site-topbar" id="site-topbar">
        <div class="topbar-inner">
            {* Topbar Left: Badges & Publisher / Open Access Info *}
            <div class="topbar-left">
                <span class="topbar-badge topbar-badge-oa">
                    <span class="topbar-pulse" aria-hidden="true"></span>
                    <span>{translate key="plugins.themes.glassTheme.openAccess"}</span>
                </span>

                {if $journalAcronym}
                    <span class="topbar-divider" aria-hidden="true"></span>
                    <span class="topbar-acronym">{$journalAcronym|escape}</span>
                {/if}

                {if $publisherInst}
                    <span class="topbar-divider" aria-hidden="true"></span>
                    <span class="topbar-publisher" title="{translate key='plugins.themes.glassTheme.sidebar.publisher'}">
                        <span class="topbar-icon" aria-hidden="true">🏛️</span>
                        <span class="topbar-text">{$publisherInst|escape}</span>
                    </span>
                {/if}
            </div>

            {* Topbar Right: e-ISSN / p-ISSN data & Quick Controls *}
            <div class="topbar-right">
                {* ISSN Data Pill *}
                <div class="topbar-issn" aria-label="Journal ISSN">
                    {if $onlineIssn}
                        <div class="issn-chip issn-online" title="Online ISSN (e-ISSN)">
                            <span class="issn-dot" aria-hidden="true"></span>
                            <span class="issn-label">e-ISSN:</span>
                            <strong class="issn-value">{$onlineIssn|escape}</strong>
                        </div>
                    {/if}
                    {if $printIssn}
                        <div class="issn-chip issn-print" title="Print ISSN (p-ISSN)">
                            <span class="issn-label">p-ISSN:</span>
                            <strong class="issn-value">{$printIssn|escape}</strong>
                        </div>
                    {/if}
                    {if !$onlineIssn && !$printIssn}
                        <div class="issn-chip issn-online" title="Electronic ISSN">
                            <span class="issn-dot" aria-hidden="true"></span>
                            <span class="issn-label">e-ISSN:</span>
                            <strong class="issn-value">—</strong>
                        </div>
                    {/if}
                </div>

                {* Language Switcher (Compact in Topbar) *}
                {if count($supportedLocales) > 1}
                <div class="locale-switcher" role="navigation"
                     aria-label="{translate key='plugins.themes.glassTheme.languageSwitcher'}">
                    <button class="locale-btn" id="locale-btn"
                            aria-haspopup="true" aria-expanded="false"
                            aria-controls="locale-dropdown">
                        <span aria-hidden="true">🌐</span>
                        <span>{$currentLocale|upper|truncate:2:""}</span>
                        <svg width="10" height="6" viewBox="0 0 10 6" fill="none" aria-hidden="true">
                            <path d="M1 1l4 4 4-4" stroke="currentColor" stroke-width="1.5"
                                  stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <div class="locale-dropdown" id="locale-dropdown" role="listbox">
                        {foreach from=$supportedLocales key=localeKey item=localeName}
                            <a class="locale-option{if $localeKey eq $currentLocale} current{/if}"
                               href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='user'
                                           op='setLocale' path=$localeKey
                                           source=$smarty.server.REQUEST_URI}"
                               data-locale="{$localeKey|escape}"
                               role="option"
                               aria-selected="{if $localeKey eq $currentLocale}true{else}false{/if}">
                                {if $localeKey eq 'en' || $localeKey eq 'en_US'}🇬🇧{/if}
                                {if $localeKey eq 'id' || $localeKey eq 'id_ID'}🇮🇩{/if}
                                {$localeName|escape}
                            </a>
                        {/foreach}
                    </div>
                </div>
                {/if}

                {* Theme Toggle Button *}
                <button class="theme-toggle topbar-theme-toggle"
                        id="theme-toggle-btn"
                        type="button"
                        aria-label="{translate key='plugins.themes.glassTheme.toggleTheme'}"
                        title="{translate key='plugins.themes.glassTheme.toggleTheme'}">
                    🌙
                </button>
            </div>
        </div>
    </div>

    {* ═══════════════════════════════════════════════════════════════════════════
       LAYER 2: MAIN NAVIGATION BAR (STICKY)
       ═══════════════════════════════════════════════════════════════════════════ *}
    <nav class="glass-nav site-nav{if $requestedPage && $requestedPage neq 'index'} has-breadcrumbs{/if}" id="site-nav" role="navigation"
         aria-label="{translate key='common.navigation.site'}">
        <div class="nav-inner">

            {* Brand / Logo *}
            <a class="nav-brand" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='index'}"
               aria-label="{$currentJournal->getLocalizedName()|escape}">
                {if $currentJournal->getData('journalThumbnail')}
                    <img src="{$publicFilesDir}/{$currentJournal->getData('journalThumbnail')}"
                         alt="{$currentJournal->getLocalizedName()|escape}"
                         width="34" height="34"
                         class="nav-brand-img"
                         style="border-radius:8px;object-fit:cover;">
                {else}
                    <div class="nav-brand-icon" aria-hidden="true">
                        <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                            <rect width="32" height="32" rx="8" fill="var(--color-accent)" opacity=".95"/>
                            <text x="16" y="22" text-anchor="middle" fill="white"
                                  font-family="Inter,sans-serif" font-size="15" font-weight="700">
                                {$currentJournal->getLocalizedName()|substr:0:1|upper|default:"J"}
                            </text>
                        </svg>
                    </div>
                {/if}
                <span class="nav-brand-title">{$currentJournal->getLocalizedName()|truncate:32:"…"}</span>
            </a>

            {* Desktop navigation links *}
            <ul class="nav-links" role="list">
                <li class="nav-link-item">
                    <a class="nav-link{if $requestedPage eq 'index' || !$requestedPage} active{/if}"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='index'}">
                        {translate key="navigation.homePage"}
                    </a>
                </li>
                <li class="nav-link-item">
                    <a class="nav-link{if $requestedPage eq 'issue' && $requestedOp neq 'archive'} active{/if}"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='issue' op='current'}">
                        {translate key="plugins.themes.glassTheme.currentIssue"}
                    </a>
                </li>
                <li class="nav-link-item">
                    <a class="nav-link{if $requestedPage eq 'issue' && $requestedOp eq 'archive'} active{/if}"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='issue' op='archive'}">
                        {translate key="navigation.archives"}
                    </a>
                </li>
                <li class="nav-link-item nav-has-dropdown">
                    <a class="nav-link{if $requestedPage eq 'about'} active{/if}"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about'}"
                       aria-haspopup="true" aria-expanded="false">
                        {translate key="navigation.about"}<span class="nav-caret"></span>
                    </a>
                    <div class="nav-dropdown" role="menu">
                        <a class="nav-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about'}" role="menuitem">
                            <span class="dropdown-item-icon">📖</span>
                            <span>{translate key="about.aboutContext"}</span>
                        </a>
                        <a class="nav-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about' op='editorialTeam'}" role="menuitem">
                            <span class="dropdown-item-icon">👥</span>
                            <span>{translate key="about.editorialTeam"}</span>
                        </a>
                        <a class="nav-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about' op='submissions'}" role="menuitem">
                            <span class="dropdown-item-icon">📝</span>
                            <span>{translate key="about.submissions"}</span>
                        </a>
                        <a class="nav-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about' op='contact'}" role="menuitem">
                            <span class="dropdown-item-icon">✉️</span>
                            <span>{translate key="about.contact"}</span>
                        </a>
                    </div>
                </li>
                <li class="nav-link-item">
                    <a class="nav-link{if $requestedPage eq 'search'} active{/if}"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='search'}">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block;vertical-align:-2px;margin-right:3px;" aria-hidden="true">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        {translate key="common.search"}
                    </a>
                </li>
            </ul>

            {* Right-side actions *}
            <div class="nav-actions">

                {* User Account Menu (Logged In) *}
                {if $isUserLoggedIn}
                <div class="user-menu" id="user-menu-root">
                    <button class="user-btn" id="user-btn" aria-haspopup="true" aria-expanded="false" aria-controls="user-dropdown">
                        <div class="user-avatar">
                            {assign var="userAvatar" value=$currentUser->getData('avatar')}
                            {if $userAvatar}
                                <img src="{$publicFilesDir}/{$userAvatar.uploadName|escape:"url"}" alt="{$currentUser->getFullName()|escape}">
                            {else}
                                <span>{$currentUser->getLocalizedGivenName()|substr:0:1|upper}{$currentUser->getLocalizedFamilyName()|substr:0:1|upper}</span>
                            {/if}
                        </div>
                        <span class="user-name">{$currentUser->getLocalizedGivenName()|escape}</span>
                        <svg width="10" height="6" viewBox="0 0 10 6" fill="none" aria-hidden="true" style="margin-left:2px;opacity:0.5;">
                            <path d="M1 1l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <div class="user-dropdown" id="user-dropdown" role="menu">
                        <div class="user-dropdown-header">
                            <span class="name">{$currentUser->getFullName()|escape}</span>
                            <span class="email">{$currentUser->getEmail()|escape}</span>
                        </div>
                        <a class="user-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='dashboard'}" role="menuitem">
                            <span>📊</span> {translate key="navigation.dashboard"}
                        </a>
                        <a class="user-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='user' op='profile'}" role="menuitem">
                            <span>👤</span> {translate key="user.profile"}
                        </a>
                        <a class="user-dropdown-item" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='submission'}" role="menuitem">
                            <span>📝</span> {translate key="navigation.submissions"}
                        </a>
                        <div style="border-top:1px solid var(--glass-border);margin:0.5rem 0;"></div>
                        <a class="user-dropdown-item logout" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='login' op='signOut'}" role="menuitem">
                            <span>🚪</span> {translate key="user.logOut"}
                        </a>
                    </div>
                </div>
                {else}
                    {* Non-logged in: Login Link *}
                    <a class="nav-link nav-login-link" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='login'}">
                        {translate key="user.login"}
                    </a>
                {/if}

                {* Submit/Register CTA Button *}
                {if $currentJournal->getData('allowPublicRegistration') || $isUserLoggedIn}
                    <a class="glass-btn glass-btn-primary nav-cta-btn"
                       href="{if $isUserLoggedIn}
                                  {url router=PKP\core\PKPApplication::ROUTE_PAGE page='submission'}
                              {else}
                                  {url router=PKP\core\PKPApplication::ROUTE_PAGE page='register'}
                              {/if}">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            {if $isUserLoggedIn}
                                <path d="M12 5v14M5 12h14"/>
                            {else}
                                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="8.5" cy="7" r="4"></circle>
                                <line x1="20" y1="8" x2="20" y2="14"></line>
                                <line x1="23" y1="11" x2="17" y2="11"></line>
                            {/if}
                        </svg>
                        <span>
                            {if $isUserLoggedIn}
                                {translate key="author.submit"}
                            {else}
                                {translate key="user.register"}
                            {/if}
                        </span>
                    </a>
                {/if}

                {* Hamburger — mobile only *}
                <button class="nav-toggle" id="nav-toggle"
                        aria-controls="mobile-menu"
                        aria-expanded="false"
                        aria-label="{translate key='plugins.themes.glassTheme.openMenu'}">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </div>

        {* Mobile full-screen menu drawer *}
        <div class="mobile-menu" id="mobile-menu" role="dialog"
             aria-label="{translate key='common.navigation.site'}">
            
            {* Mobile ISSN Header Chip *}
            {if $onlineIssn || $printIssn}
            <div class="mobile-menu-issn">
                {if $onlineIssn}
                    <span class="issn-chip issn-online">
                        <span class="issn-dot" aria-hidden="true"></span>
                        <span class="issn-label">e-ISSN:</span>
                        <strong class="issn-value">{$onlineIssn|escape}</strong>
                    </span>
                {/if}
                {if $printIssn}
                    <span class="issn-chip issn-print">
                        <span class="issn-label">p-ISSN:</span>
                        <strong class="issn-value">{$printIssn|escape}</strong>
                    </span>
                {/if}
            </div>
            {/if}

            <ul style="list-style:none;display:flex;flex-direction:column;gap:0.25rem;">
                {foreach from=[
                    ['page' => 'index',   'label' => 'navigation.homePage'],
                    ['page' => 'issue',   'label' => 'plugins.themes.glassTheme.currentIssue', 'op' => 'current'],
                    ['page' => 'issue',   'label' => 'navigation.archives', 'op' => 'archive'],
                    ['page' => 'about',   'label' => 'navigation.about'],
                    ['page' => 'search',  'label' => 'common.search']
                ] item=item}
                <li>
                    <a class="nav-link"
                       style="display:block;padding:.75rem 1rem;border-radius:.5rem;"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE
                                   page=$item.page op=$item.op|default:''}">
                        {translate key=$item.label}
                    </a>
                </li>
                {/foreach}
                {if $isUserLoggedIn}
                <li style="margin-top:0.75rem;padding-top:0.75rem;border-top:1px solid var(--glass-border);">
                    <div style="display:flex;align-items:center;gap:0.75rem;padding:0.5rem 1rem;">
                        <div class="user-avatar" style="width:2.5rem;height:2.5rem;font-size:1rem;">
                             {assign var="userAvatar" value=$currentUser->getData('avatar')}
                             {if $userAvatar}
                                <img src="{$publicFilesDir}/{$userAvatar.uploadName|escape:"url"}" alt="{$currentUser->getFullName()|escape}">
                            {else}
                                <span>{$currentUser->getLocalizedGivenName()|substr:0:1|upper}{$currentUser->getLocalizedFamilyName()|substr:0:1|upper}</span>
                            {/if}
                        </div>
                        <div style="display:flex;flex-direction:column;">
                            <span style="font-weight:700;font-size:0.95rem;color:var(--glass-text);">{$currentUser->getFullName()|escape}</span>
                            <span style="font-size:0.75rem;color:var(--glass-text-subtle);">{$currentUser->getEmail()|escape}</span>
                        </div>
                    </div>
                </li>
                <li>
                    <a class="nav-link" style="display:block;padding:.75rem 1rem;border-radius:.5rem;" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='dashboard'}">
                        <span>📊</span> {translate key="navigation.dashboard"}
                    </a>
                </li>
                <li>
                    <a class="nav-link" style="display:block;padding:.75rem 1rem;border-radius:.5rem;" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='user' op='profile'}">
                        <span>👤</span> {translate key="user.profile"}
                    </a>
                </li>
                <li>
                    <a class="nav-link" style="display:block;padding:.75rem 1rem;border-radius:.5rem;" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='submission'}">
                        <span>📝</span> {translate key="navigation.submissions"}
                    </a>
                </li>
                <li>
                    <a class="nav-link" style="display:block;padding:.75rem 1rem;border-radius:.5rem;color:#ef4444;" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='login' op='signOut'}">
                        <span>🚪</span> {translate key="user.logOut"}
                    </a>
                </li>
                {else}
                <li style="margin-top:0.5rem;display:flex;flex-direction:column;gap:0.5rem;">
                    <a class="glass-btn glass-btn-primary" style="width:100%;justify-content:center;"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='register'}">
                        {translate key="user.register"}
                    </a>
                    <a class="glass-btn glass-btn-ghost" style="width:100%;justify-content:center;"
                       href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='login'}">
                        {translate key="user.login"}
                    </a>
                </li>
                {/if}
            </ul>
        </div>
    </nav>

    <div class="pkp_structure_page">
        {* Global Breadcrumb Bar for all sub-pages *}
        {if $requestedPage && $requestedPage neq 'index'}
            {include file="frontend/components/breadcrumbs.tpl"}
        {/if}
