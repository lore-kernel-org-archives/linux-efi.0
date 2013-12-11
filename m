From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Date: Wed, 11 Dec 2013 12:02:27 +0100
Message-ID: <20131211110227.GK22356@rocoto.smurfnet.nu>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131211103903.GC19196@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com, toshi.kani@hp.com, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 11, 2013 at 10:39:03AM +0000, Matt Fleming wrote:
> Leif, Mark, does this patch look OK for ARM? We'd need to introduce a
> new early_memunmap() function so that things still build, but that
> should be straight forward. You'd even be able to get rid of the
> asymmetry in uefi_init() where you map efi.systab with early_memremap()
> but unmap it with early_iounmap().

This patch looks splendid for ARM. As long as Mark can get the new
function into an update to the early_*remap() set, I can include this
in my next version - which is coming this week.

/
    Leif
