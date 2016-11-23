From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 09:53:00 +0000
Message-ID: <31281.1479894780@warthog.procyon.org.uk>
References: <20161123093122.GB2071@wunner.de> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161123093122.GB2071@wunner.de>
Content-ID: <31280.1479894780.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> It just occurred to me that the boot_params struct is populated in
> make_boot_params(), perhaps it makes sense to move this line there.
> Otherwise LGTM.

Ummm...  Looking at arch/x86/boot/compressed/head_64.S, make_boot_params() is
only called if the stub is entered through efi_pe_entry, not if entered
through efi64_stub_entry, whereas efi_main() is called in both cases.  I think
entry through efi32_stub_entry may also skip make_boot_params().

The comment on make_boot_params() suggests that this function is only used if
whoever booted the kernel didn't supply it.

David
