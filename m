From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Wed, 1 Feb 2017 14:44:48 +0000
Message-ID: <CAKv+Gu8FOcMx0UXXdd3nhE+PUPzbEn9X=kBQDfkLOZBvVu-8fg@mail.gmail.com>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com>
 <10454.1485889162@warthog.procyon.org.uk> <CAKv+Gu_gy6575axL6M64OSo33ZM2dnbs7cajqJRd8VtbjAXCTw@mail.gmail.com>
 <20578.1485952425@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20578.1485952425@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 1 February 2017 at 12:33, David Howells <dhowells@redhat.com> wrote:
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> So this patch should take AuditMode into account, but not DeployedMode, i.e.,
>>
>> SecureBoot == 0x1
>> SetupMode == 0x0
>> AuditMode == 0x0 (or non-existent)
>
> If we're in audit mode or setup mode SecureBoot==0 and SetupMode==1 according
> to the flowchart, so the check of AuditMode would seem redundant.
>
> Further, the checks above don't seem to differentiate deployed mode from user
> mode.  Should they?
>

>From the OS pov, UserMode and DeployedMode are the same, the only
difference being that AuditMode may be entered from UserMode simply by
setting the variable to 0x1 (which can only be done before
ExitBootServices()). And since AuditMode implies SetupMode (according
to the diagram), you are right that we don't need to care about
AuditMode either. AFAICT, that makes the entire patch unnecessary, so
let's drop it for now.
