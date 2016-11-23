From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime services [ver #2]
Date: Wed, 23 Nov 2016 11:46:38 +0000
Message-ID: <6125.1479901598@warthog.procyon.org.uk>
References: <20161123102747.GD24624@leverpostej> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161123102747.GD24624@leverpostej>
Content-ID: <6124.1479901598.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: dhowells@redhat.com, lukas@wunner.de, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Mark Rutland <mark.rutland@arm.com> wrote:

> Any reason to not Cc LAKML?

Probably not.

> On Wed, Nov 23, 2016 at 12:22:43AM +0000, David Howells wrote:
> > Provide the ability to perform mixed-mode runtime service calls for arm in
> > the same way that commit 0a637ee61247bd4bed9b2a07568ef7a1cfc76187
> > ("x86/efi: Allow invocation of arbitrary boot services") provides the
> > ability to invoke arbitrary boot services.
> 
> I'm not sure I understand. On arm/arm64, "mixed-mode" simply isn't possible.
> 
> I see we already call runtime services directly in efi_get_secureboot()
> in drivers/firmware/efi/libstub/arm-stub.c.
> 
> If this is just to provide a consistent API for the stub, please note
> that.

How about:

    arm/efi: Allow invocation of arbitrary runtime services
    
    efi_call_runtime() is provided for x86 to be able abstract mixed mode
    support.  Provide this for ARM also so that common code work in mixed mode
    also.

David
