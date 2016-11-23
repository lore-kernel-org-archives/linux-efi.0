From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 11:10:50 +0100
Message-ID: <20161123101050.GA2113@wunner.de>
References: <20161123093122.GB2071@wunner.de>
 <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
 <31281.1479894780@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31281.1479894780@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 09:53:00AM +0000, David Howells wrote:
> Lukas Wunner <lukas@wunner.de> wrote:
> > It just occurred to me that the boot_params struct is populated in
> > make_boot_params(), perhaps it makes sense to move this line there.
> > Otherwise LGTM.
> 
> Ummm...  Looking at arch/x86/boot/compressed/head_64.S, make_boot_params() is
> only called if the stub is entered through efi_pe_entry, not if entered
> through efi64_stub_entry, whereas efi_main() is called in both cases.  I think
> entry through efi32_stub_entry may also skip make_boot_params().
> 
> The comment on make_boot_params() suggests that this function is only used if
> whoever booted the kernel didn't supply it.

Good point. :-) I didn't dig this deep, it was just something that
crossed my mind when skimming over the patch.

You're also right about the (efi_##f##_t *) addition in patch 2.

Thanks,

Lukas
