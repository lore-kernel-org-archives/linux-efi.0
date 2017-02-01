From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Wed, 1 Feb 2017 10:15:02 +0000
Message-ID: <CAKv+Gu_gy6575axL6M64OSo33ZM2dnbs7cajqJRd8VtbjAXCTw@mail.gmail.com>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com> <10454.1485889162@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10454.1485889162-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 January 2017 at 18:59, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> > UEFI-2.6 adds a new variable, DeployedMode.  If it exists, this must be 1
>> > if we're to engage lockdown mode.
>> >
>> > Reported-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
>> > Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Interestingly, the string 'DeployedMode' appears zero times in the
>> EDK2 codebase, so I wonder if it makes any sense to merge this now.
>> The string 'AuditMode' does appear once, but in a comment
>
> It's in the standard, so shouldn't we check for it?
>
>> In any case, the logic is not entirely correct either: apologies if it
>> was me who caused any confusion here, but it seems DeployedMode could
>> legally be 0 or 1 while secure boot is in fact enabled. It is actually
>> AuditMode that should be taken into account here, i.e., if AuditMode
>> == 1, the firmware ignores invalid or missing signatures. If
>> SecureBoot == 0x1, SetupMode == 0x0 and AuditMode == 0x0 (or
>> non-existent), signature verification is performed regardless of the
>> value (or existence) of DeployedMode.
>>
>> So I propose to respin this patch to treat AuditMode == 0x1 as 'secure
>> boot disabled', and ignore if it is missing.
>
> Ummm...  This might conflict what said:
>
> | Since you seem to be using this to mean "is the platform locked down?",
> | this looks to be no longer complete in the UEFI 2.6 world.  If
> | DeployedMode == 0, even if SecureBoot == 1 and SetupMode == 0, you can
> | remove the platform key by writing 1 to AuditMode and gain control of
> | the secure variables.  The lock down state becomes DeployedMode == 1,
> | SecureBoot == 1 and SetupMode == 0
> |
> | See the diagram on page 1817
> |
> | http://www.uefi.org/sites/default/files/resources/UEFI%20Spec%202_6.pdf
>
> Looking again at that diagram, should I be checking all four variables
> (SecureBoot, SetupMode, DeployedMode and AuditMode)?  And/or should I treat
> audit mode differently to deployed mode?
>

Well, we are trying to decide whether the system is locked down or
not. AuditMode is only writable before ExitBootServices(), and when
AuditMode == 0, signature verification occurs as usual, regardless of
the value of DeployedMode. Whether someone could turn on AuditMode on
the *next* boot does not sound that relevant to me, since someone
could also re-enter SetupMode in the same way.

So this patch should take AuditMode into account, but not DeployedMode, i.e.,

SecureBoot == 0x1
SetupMode == 0x0
AuditMode == 0x0 (or non-existent)

implies a locked down state.

> Further, there doesn't seem to be a state in which SecureBoot is shown as
> being 1.
>

Yes, that is sloppy. But the fact that EDK2, being the v2.6 reference,
does not implement any of this *at all* is much more worrying to me,
given that UDK2017 based firmware will certainly turn up in production
systems.
