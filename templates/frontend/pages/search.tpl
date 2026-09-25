{**
 * @file templates/frontend/pages/search.tpl
 *
 * Glass Theme — Search page
 * Includes: glass search hero, animated results, glass result cards,
 *           skeleton loading state, pagination.
 *}

{include file="frontend/components/header.tpl" pageTitle="common.search"}

<main id="main-content" class="page-fade">

    {* ── Search Hero ─────────────────────────────────────────────────────── *}
    <section class="search-hero" aria-labelledby="search-heading">
        <div class="hero-orb hero-orb-1" aria-hidden="true"
            style="width:300px;height:300px;top:-80px;left:10%;opacity:.6;"></div>
        <div class="hero-orb hero-orb-2" aria-hidden="true"
            style="width:250px;height:250px;bottom:-60px;right:15%;opacity:.5;"></div>

        <div style="position:relative;z-index:1;">
            <span class="section-eyebrow">{translate key="common.search"}</span>
            <h1 class="section-title" id="search-heading" style="margin:.5rem 0 1.5rem;">
                {translate key="plugins.themes.glassTheme.search.heading"}
            </h1>

            <form method="get" action="{url page='search' op='search'}"
                class="search-box" role="search">
                <label for="search-input" class="sr-only">{translate key="common.search"}</label>

                {* Search icon *}
                <svg class="search-icon" width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
                    <circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.6" />
                    <path d="M13 13l3 3" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" />
                </svg>

                <input id="search-input" class="glass-input" type="search" name="query" value="{$query|escape}"
                    placeholder="{translate key='plugins.themes.glassTheme.search.placeholder'}" autocomplete="off"
                    aria-label="{translate key='common.search'}">

                <button type="submit" class="glass-btn glass-btn-primary search-submit">
                    {translate key="common.search"}
                </button>
            </form>

            {* Keyboard hint *}
            <p style="font-size:.75rem;color:var(--glass-text-subtle);margin-top:.875rem;">
                {translate key="plugins.themes.glassTheme.search.tip"}
                <kbd style="padding:.1rem .35rem;border:1px solid var(--glass-border);
                             border-radius:.25rem;font-family:monospace;font-size:.75rem;">/</kbd>
            </p>
        </div>
    </section>

    {* ── Results ─────────────────────────────────────────────────────────── *}
    <section class="section" style="padding-top:1.5rem;">
        <div class="page-container">

            {* Calculate result count reliably across OJS 3.3, 3.4, and 3.5 *}
            {if $results}
                {if method_exists($results, 'count')}
                    {assign var="resultsCount" value=$results->count()}
                {elseif method_exists($results, 'getCount')}
                    {assign var="resultsCount" value=$results->getCount()}
                {else}
                    {assign var="resultsCount" value=$results|@count}
                {/if}
            {else}
                {assign var="resultsCount" value=0}
            {/if}

            {if $query}
                {* Result count *}
                <div class="reveal" style="margin-bottom:1.5rem;font-size:.875rem;
                                           color:var(--glass-text-muted);">
                    {if $resultsCount > 0}
                        {translate key="plugins.themes.glassTheme.search.results"
                                           count=$resultsCount
                                           query=$query|escape}
                    {else}
                        {translate key="plugins.themes.glassTheme.search.noResults"
                                           query=$query|escape}
                    {/if}
                </div>
            {/if}

            {if $results && $resultsCount > 0}
                <div style="display:flex;flex-direction:column;gap:1.25rem;">
                    {foreach from=$results item=result}
                        {* Support both OJS 3.4/3.5 array format ($result.submission) and legacy Submission object *}
                        {if is_array($result) && $result.submission}
                            {assign var="article" value=$result.submission}
                        {elseif is_object($result) && method_exists($result, 'getSubmission')}
                            {assign var="article" value=$result->getSubmission()}
                        {else}
                            {assign var="article" value=$result}
                        {/if}

                        {if $article}
                            {if method_exists($article, 'getCurrentPublication')}
                                {assign var="publication" value=$article->getCurrentPublication()}
                            {else}
                                {assign var="publication" value=null}
                            {/if}

                            {if method_exists($article, 'getBestId')}
                                {assign var="articleBestId" value=$article->getBestId()}
                            {elseif method_exists($article, 'getId')}
                                {assign var="articleBestId" value=$article->getId()}
                            {else}
                                {assign var="articleBestId" value=""}
                            {/if}

                            <article class="glass-card article-card reveal"
                                aria-labelledby="result-{$articleBestId|escape}-title">

                                {if $publication && $publication->getData('sectionTitle')}
                                    <div class="article-card-section">{$publication->getData('sectionTitle')|escape}</div>
                                {/if}

                                <h2 class="article-card-title" id="result-{$articleBestId|escape}-title">
                                    <a href="{url page='article' op='view' path=$articleBestId}">
                                        {if $publication}
                                            {$publication->getLocalizedData('title')|escape}
                                        {elseif method_exists($article, 'getLocalizedTitle')}
                                            {$article->getLocalizedTitle()|escape}
                                        {/if}
                                    </a>
                                </h2>

                                {if $publication}
                                    {assign var="resultAuthors" value=$publication->getData('authors')}
                                {elseif method_exists($article, 'getAuthors')}
                                    {assign var="resultAuthors" value=$article->getAuthors()}
                                {else}
                                    {assign var="resultAuthors" value=null}
                                {/if}

                                {if $resultAuthors}
                                    <div class="article-card-authors">
                                        {foreach from=$resultAuthors item=ra name=ral}
                                            {if is_object($ra) && method_exists($ra, 'getFullName')}
                                                {$ra->getFullName()|escape}{if not $smarty.foreach.ral.last}, {/if}
                                            {/if}
                                        {/foreach}
                                    </div>
                                {/if}

                                {if $publication && $publication->getLocalizedData('abstract')}
                                    <p style="font-size:.85rem;color:var(--glass-text-muted);
                                              line-height:1.65;margin-top:.25rem;">
                                        {$publication->getLocalizedData('abstract')|strip_tags|truncate:240:"…"|escape}
                                    </p>
                                {/if}

                                <div class="article-card-footer">
                                    <span>
                                        {if $publication && $publication->getData('datePublished')}
                                            {$publication->getData('datePublished')|date_format:$dateFormatShort}
                                        {/if}
                                    </span>
                                    <a class="article-card-read" href="{url page='article' op='view' path=$articleBestId}" aria-label="{translate key='submission.read'} {if $publication}{$publication->getLocalizedData('title')|escape}{/if}">
                                        {translate key="plugins.themes.glassTheme.readMore"}
                                        <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true">
                                            <path d="M1 6h10M6 1l5 5-5 5" stroke="currentColor" stroke-width="1.5"
                                                stroke-linecap="round" stroke-linejoin="round" />
                                        </svg>
                                    </a>
                                </div>
                            </article>
                        {/if}
                    {/foreach}
                </div>

                {include file="frontend/components/pagination.tpl" iterator=$results}

            {elseif $query}
                {* No results state *}
                <div class="glass-card reveal" style="padding:3rem;text-align:center;">
                    <div style="font-size:3rem;margin-bottom:1rem;" aria-hidden="true">🔍</div>
                    <h2 style="font-size:1.1rem;color:var(--glass-text);margin-bottom:.5rem;">
                        {translate key="plugins.themes.glassTheme.search.noResultsHeading"}
                    </h2>
                    <p style="font-size:.875rem;color:var(--glass-text-muted);">
                        {translate key="plugins.themes.glassTheme.search.noResultsHint"}
                    </p>
                </div>

            {else}
                {* Initial state — show search tips *}
                <div class="card-grid" style="grid-template-columns:repeat(auto-fill,minmax(260px,1fr));">
                    {foreach from=[
                            ['icon'=>'📖','key'=>'plugins.themes.glassTheme.search.tip1'],
                            ['icon'=>'👤','key'=>'plugins.themes.glassTheme.search.tip2'],
                            ['icon'=>'🏷️','key'=>'plugins.themes.glassTheme.search.tip3']
                        ] item=tip name=tips}
                    <div class="glass-card-sm reveal reveal-delay-{$smarty.foreach.tips.index + 1}"
                        style="padding:1.5rem;text-align:center;">
                        <div style="font-size:2rem;margin-bottom:.75rem;" aria-hidden="true">
                            {$tip.icon}
                        </div>
                        <p style="font-size:.85rem;color:var(--glass-text-muted);">
                            {translate key=$tip.key}
                        </p>
                    </div>
                {/foreach}
            </div>
            {/if}

        </div>
    </section>

</main>

{include file="frontend/components/footer.tpl"}