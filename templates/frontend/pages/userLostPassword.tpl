{**
 * @file templates/frontend/pages/userLostPassword.tpl
 *
 * Glass Theme — Lost / Reset Password page
 *}

{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<main id="main-content" class="page-fade">

    <section class="section" style="min-height: 80vh; display: flex; align-items: center; justify-content: center; position: relative;">
        
        {* Decorative Orbs *}
        <div class="hero-orb hero-orb-1" aria-hidden="true" style="width:400px;height:400px;top:10%;left:10%;opacity:.4;"></div>
        <div class="hero-orb hero-orb-2" aria-hidden="true" style="width:350px;height:350px;bottom:10%;right:10%;opacity:.3;"></div>

        <div class="page-container" style="width: 100%; max-width: 480px; position: relative; z-index: 1;">
            <div class="glass-card" style="padding: 3rem 2.5rem;">
                
                <div style="text-align: center; margin-bottom: 2rem;">
                    <div style="display: inline-flex; align-items: center; justify-content: center; width: 56px; height: 56px; border-radius: 16px; background: var(--glass-badge-bg); border: 1px solid var(--glass-badge-border); color: var(--color-accent-light); margin-bottom: 1.25rem; box-shadow: 0 4px 20px rgba(var(--glass-accent-rgb), 0.25);">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <circle cx="8" cy="15" r="4"/>
                            <path d="m10.85 12.15 7.65-7.65a1 1 0 0 1 1.41 0l1.59 1.59a1 1 0 0 1 0 1.41L20 9l-1.5-1.5"/>
                            <path d="m15.5 6.5 2 2"/>
                        </svg>
                    </div>
                    <h1 class="section-title" style="font-size: 1.75rem; margin-bottom: .5rem;">
                        {translate key="user.login.resetPassword"}
                    </h1>
                    <p style="color: var(--glass-text-muted); font-size: .9rem; line-height: 1.6;">
                        {translate key="user.login.resetPasswordInstructions"}
                    </p>
                </div>

                {if $error}
                    <div style="background: rgba(239, 68, 68, 0.15); color: #fca5a5; border: 1px solid rgba(239, 68, 68, 0.3); padding: .75rem 1rem; border-radius: .5rem; margin-bottom: 1.5rem; font-size: .85rem; text-align: center; display: flex; align-items: center; gap: .5rem; justify-content: center;">
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true" style="flex-shrink: 0;">
                            <path d="M8 1a7 7 0 100 14A7 7 0 008 1zm0 3.5a.75.75 0 01.75.75v3.5a.75.75 0 01-1.5 0v-3.5A.75.75 0 018 4.5zm0 7a.875.875 0 110-1.75.875.875 0 010 1.75z" fill="currentColor"/>
                        </svg>
                        <span>{translate key=$error reason=$reason}</span>
                    </div>
                {/if}

                {if $message}
                    <div class="badge badge-accent" style="width: 100%; justify-content: center; margin-bottom: 1.5rem; padding: .75rem; border-radius: .5rem; font-size: .85rem;">
                        {translate key=$message}
                    </div>
                {/if}

                <form class="cmp_form lost_password" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post">
                    {csrf}

                    <div style="margin-bottom: 1.5rem;">
                        <label for="email" style="display: block; font-size: .75rem; font-weight: 700; color: var(--color-accent-light); text-transform: uppercase; margin-bottom: .5rem; margin-left: .25rem;">
                            {translate key="user.login.registeredEmail"}
                            <span class="required" aria-hidden="true" style="color: #f87171;">*</span>
                            <span class="sr-only">{translate key="common.required"}</span>
                        </label>
                        <div style="position: relative;">
                            <input type="email" name="email" id="email" class="glass-input" 
                                   value="{$email|escape}" required aria-required="true" autocomplete="email"
                                   placeholder="{translate key="user.login.registeredEmail"}"
                                   style="padding-left: 2.75rem;">
                            <div style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--glass-text-subtle); pointer-events: none; display: flex; align-items: center;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <rect width="20" height="16" x="2" y="4" rx="2"/>
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                                </svg>
                            </div>
                        </div>
                    </div>

                    {* Altcha spam blocker (OJS 3.4/3.5) *}
                    {if $altchaEnabled}
                        <fieldset class="altcha_wrapper" style="margin-bottom: 1.5rem; border: none; padding: 0;">
                            <div class="fields">
                                <altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
                            </div>
                        </fieldset>
                    {/if}

                    {* reCAPTCHA support if configured *}
                    {if $reCaptchaHtml}
                        <div class="recaptcha_wrapper" style="margin-bottom: 1.5rem; display: flex; justify-content: center;">
                            {$reCaptchaHtml}
                        </div>
                    {/if}

                    <button type="submit" class="glass-btn glass-btn-primary" style="width: 100%; justify-content: center; padding: .875rem;">
                        {translate key="user.login.resetPassword"}
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true" style="margin-left: .25rem;">
                            <path d="M9 3l5 5-5 5M1 8h13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>

                    <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--glass-border); display: flex; align-items: center; justify-content: space-between; font-size: .85rem; flex-wrap: wrap; gap: .75rem;">
                        <a href="{url page="login"}" style="color: var(--color-accent-light); text-decoration: none; display: inline-flex; align-items: center; gap: .375rem; font-weight: 500;">
                            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                                <path d="M7 13L2 8l5-5M2 8h12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            {translate key="user.login"}
                        </a>

                        {if !$disableUserReg}
                            <a href="{url page="user" op="register" source=$source}" style="color: var(--glass-text-muted); text-decoration: none; font-weight: 500;">
                                {translate key="user.login.registerNewAccount"}
                            </a>
                        {/if}
                    </div>
                </form>

            </div>
        </div>
    </section>

</main>

{include file="frontend/components/footer.tpl"}
