{**
 * @file templates/frontend/components/pagination.tpl
 *
 * Glass Theme — Glass-style pagination component
 *
 * @uses $iterator  ItemIterator
 * @uses $page      current page number
 * @uses $count     total number of items
 * @uses $pageUrl   URL for generating page links (uses {page} as placeholder)
 *}

{if $iterator && $iterator->getPageCount() > 1}
{assign var="totalPages" value=$iterator->getPageCount()}
{assign var="currentPage" value=$iterator->getPage()}

<nav class="pagination" aria-label="{translate key='common.pagination'}">

    {* Previous button *}
    {if $iterator->hasPrevious()}
        {if $pageUrl}
            {assign var="prevLink" value=$pageUrl|replace:"{page}":$iterator->getPreviousPage()}
        {else}
            {capture assign="prevLink"}{url params=$smarty.get searchPage=$iterator->getPreviousPage()}{/capture}
        {/if}
        <a class="page-btn" href="{$prevLink|escape}" rel="prev" aria-label="{translate key='common.previous'}">
            <svg width="7" height="12" viewBox="0 0 7 12" fill="none" aria-hidden="true">
                <path d="M6 1L1 6l5 5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </a>
    {else}
        <span class="page-btn" aria-disabled="true" aria-label="{translate key='common.previous'}">
            <svg width="7" height="12" viewBox="0 0 7 12" fill="none" aria-hidden="true">
                <path d="M6 1L1 6l5 5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </span>
    {/if}

    {* Page number buttons — show up to 7 links, ellipsis for the rest *}
    {for $p = 1 to $totalPages}
        {if $p == 1
            || $p == $totalPages
            || ($p >= $currentPage - 2 && $p <= $currentPage + 2)}

            {if $p == $currentPage}
                <span class="page-btn active" aria-current="page">{$p}</span>
            {else}
                {if $pageUrl}
                    {assign var="pageLink" value=$pageUrl|replace:"{page}":$p}
                {else}
                    {capture assign="pageLink"}{url params=$smarty.get searchPage=$p}{/capture}
                {/if}
                <a class="page-btn" href="{$pageLink|escape}" aria-label="{translate key='common.pageNum' page=$p}">{$p}</a>
            {/if}

        {elseif ($p == $currentPage - 3 && $currentPage > 4)
              || ($p == $currentPage + 3 && $currentPage < $totalPages - 3)}
            <span class="page-btn" aria-hidden="true" style="pointer-events:none;opacity:.5;">…</span>
        {/if}
    {/for}

    {* Next button *}
    {if $iterator->hasNext()}
        {if $pageUrl}
            {assign var="nextLink" value=$pageUrl|replace:"{page}":$iterator->getNextPage()}
        {else}
            {capture assign="nextLink"}{url params=$smarty.get searchPage=$iterator->getNextPage()}{/capture}
        {/if}
        <a class="page-btn" href="{$nextLink|escape}" rel="next" aria-label="{translate key='common.next'}">
            <svg width="7" height="12" viewBox="0 0 7 12" fill="none" aria-hidden="true">
                <path d="M1 1l5 5-5 5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </a>
    {else}
        <span class="page-btn" aria-disabled="true" aria-label="{translate key='common.next'}">
            <svg width="7" height="12" viewBox="0 0 7 12" fill="none" aria-hidden="true">
                <path d="M1 1l5 5-5 5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </span>
    {/if}

</nav>
{/if}
