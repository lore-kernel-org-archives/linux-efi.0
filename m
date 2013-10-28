From: Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Date: Mon, 28 Oct 2013 11:04:02 +0100
Message-ID: <20131028100402.GC4314@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
 <20131028093206.GB4314@pd.tnic>
 <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.fedoraproject.org, kexec@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 28, 2013 at 05:51:17PM +0800, Dave Young wrote:
> It does have a warning, but it applied successfully, no idea though: 
> patches/02-efi-enter-virtual-mode-cleanup.patch
> Applying: Cleanup efi_enter_virtual_mode function
> /home/dave/git/efi/.git/rebase-apply/patch:42: space before tab in indent.
>  	efi_memory_desc_t *md, *prev_md = NULL;
> warning: 1 line adds whitespace errors.

Hmm, ok, can you upload the patches somewhere so that I can pull them?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
