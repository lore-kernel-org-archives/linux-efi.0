From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Wed, 1 Feb 2017 15:02:14 +0000
Message-ID: <CAKv+Gu9ACE23ZMcQN3NpZ_N-CWzg=N6qFVu3_UruH0miPe=izA@mail.gmail.com>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com>
 <10454.1485889162@warthog.procyon.org.uk> <CAKv+Gu_gy6575axL6M64OSo33ZM2dnbs7cajqJRd8VtbjAXCTw@mail.gmail.com>
 <20578.1485952425@warthog.procyon.org.uk> <CAKv+Gu8FOcMx0UXXdd3nhE+PUPzbEn9X=kBQDfkLOZBvVu-8fg@mail.gmail.com>
 <23750.1485961217@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23750.1485961217-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 February 2017 at 15:00, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> From the OS pov, UserMode and DeployedMode are the same, the only
>> difference being that AuditMode may be entered from UserMode simply by
>> setting the variable to 0x1 (which can only be done before
>> ExitBootServices()). And since AuditMode implies SetupMode (according
>> to the diagram), you are right that we don't need to care about
>> AuditMode either. AFAICT, that makes the entire patch unnecessary, so
>> let's drop it for now.
>
> Okay, in that case, do you want me to reissue and place a signed tag on my
> patchset without that patch, or can you pull the other patches individually?
>

Let's wait for Matt to comment on the x86 bits before reissuing
anything, but if the subsequent patches still apply cleanly, I don't
think there is a need to resend or re-sign.
