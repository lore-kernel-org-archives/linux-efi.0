From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Wed, 01 Feb 2017 15:00:17 +0000
Message-ID: <23750.1485961217@warthog.procyon.org.uk>
References: <CAKv+Gu8FOcMx0UXXdd3nhE+PUPzbEn9X=kBQDfkLOZBvVu-8fg@mail.gmail.com> <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk> <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk> <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com> <10454.1485889162@warthog.procyon.org.uk> <CAKv+Gu_gy6575axL6M64OSo33ZM2dnbs7cajqJRd8VtbjAXCTw@mail.gmail.com> <20578.1485952425@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8FOcMx0UXXdd3nhE+PUPzbEn9X=kBQDfkLOZBvVu-8fg@mail.gmail.com>
Content-ID: <23749.1485961217.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, James Bottomley <James.Bottomley@hansenpartnership.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From the OS pov, UserMode and DeployedMode are the same, the only
> difference being that AuditMode may be entered from UserMode simply by
> setting the variable to 0x1 (which can only be done before
> ExitBootServices()). And since AuditMode implies SetupMode (according
> to the diagram), you are right that we don't need to care about
> AuditMode either. AFAICT, that makes the entire patch unnecessary, so
> let's drop it for now.

Okay, in that case, do you want me to reissue and place a signed tag on my
patchset without that patch, or can you pull the other patches individually?

David
