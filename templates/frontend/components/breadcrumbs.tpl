{**
 * @file templates/frontend/components/breadcrumbs.tpl
 *
 * Glass Theme — Frosted-glass breadcrumb bar with smart dynamic fallback
 *}

{if $breadcrumbs && $breadcrumbs|@count > 1}
    {* Standard OJS provided breadcrumbs *}
    <nav class="breadcrumbs-bar" aria-label="{translate key='navigation.breadcrumb'}">
        <ol class="breadcrumbs">
            {foreach from=$breadcrumbs item=crumb name=loop}
                <li class="breadcrumb-item{if $smarty.foreach.loop.last} active{/if}"
                    {if $smarty.foreach.loop.last}aria-current="page"{/if}>

                    {if not $smarty.foreach.loop.first}
                        <svg class="breadcrumb-separator" width="6" height="10" viewBox="0 0 6 10" fill="none" aria-hidden="true">
                            <path d="M1 1l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
                                stroke-linejoin="round" />
                        </svg>
                    {/if}

                    {if $smarty.foreach.loop.last}
                        <span>{$crumb.name|escape}</span>
                    {else}
                        <a href="{$crumb.url|escape}">
                            {if $smarty.foreach.loop.first}
                                <span class="breadcrumb-home-icon" aria-hidden="true">🏠</span>
                            {/if}
                            <span>{$crumb.name|escape}</span>
                        </a>
                    {/if}
                </li>
            {/foreach}
        </ol>
    </nav>
{elseif $requestedPage && $requestedPage neq 'index'}
    {* Smart Dynamic Fallback when OJS controller does not pass $breadcrumbs on sub-pages *}
    <nav class="breadcrumbs-bar" aria-label="{translate key='navigation.breadcrumb'}">
        <ol class="breadcrumbs">
            {* 1. Home Crumb *}
            <li class="breadcrumb-item">
                <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='index'}">
                    <span class="breadcrumb-home-icon" aria-hidden="true">🏠</span>
                    <span>{translate key="navigation.homePage"}</span>
                </a>
            </li>

            {* 2. Intermediate Crumb if applicable *}
            {if $requestedPage eq 'about' && $requestedOp && $requestedOp neq 'index'}
                <li class="breadcrumb-item">
                    <svg class="breadcrumb-separator" width="6" height="10" viewBox="0 0 6 10" fill="none" aria-hidden="true">
                        <path d="M1 1l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='about'}">{translate key="navigation.about"}</a>
                </li>
            {/if}
            {if $requestedPage eq 'issue' && $requestedOp && $requestedOp neq 'archive'}
                <li class="breadcrumb-item">
                    <svg class="breadcrumb-separator" width="6" height="10" viewBox="0 0 6 10" fill="none" aria-hidden="true">
                        <path d="M1 1l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                    <a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page='issue' op='archive'}">{translate key="navigation.archives"}</a>
                </li>
            {/if}

            {* 3. Current Active Crumb *}
            <li class="breadcrumb-item active" aria-current="page">
                <svg class="breadcrumb-separator" width="6" height="10" viewBox="0 0 6 10" fill="none" aria-hidden="true">
                    <path d="M1 1l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <span>
                    {if $pageTitleTranslated}
                        {$pageTitleTranslated|escape}
                    {elseif $pageTitle}
                        {translate key=$pageTitle}
                    {elseif $requestedPage eq 'about'}
                        {if $requestedOp eq 'editorialTeam'}{translate key="about.editorialTeam"}
                        {elseif $requestedOp eq 'submissions'}{translate key="about.submissions"}
                        {elseif $requestedOp eq 'contact'}{translate key="about.contact"}
                        {elseif $requestedOp eq 'privacy'}{translate key="about.privacyStatement"}
                        {else}{translate key="about.aboutTheJournal"}
                        {/if}
                    {elseif $requestedPage eq 'issue'}
                        {if $requestedOp eq 'archive'}{translate key="navigation.archives"}
                        {else}{translate key="plugins.themes.glassTheme.currentIssue"}
                        {/if}
                    {elseif $requestedPage eq 'search'}
                        {translate key="common.search"}
                    {elseif $requestedPage eq 'login'}
                        {translate key="user.login"}
                    {elseif $requestedPage eq 'register'}
                        {translate key="user.register"}
                    {elseif $requestedPage eq 'submission'}
                        {translate key="navigation.submissions"}
                    {elseif $requestedPage eq 'user'}
                        {translate key="user.profile"}
                    {else}
                        {$requestedPage|ucfirst|escape}
                    {/if}
                </span>
            </li>
        </ol>
    </nav>
{/if}