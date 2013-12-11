From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 01/14] x86/mm: sparse warning fix for early_memremap
Date: Wed, 11 Dec 2013 12:12:40 +0100
Message-ID: <20131211111240.GE21683@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-2-git-send-email-dyoung@redhat.com>
 <20131209150521.GE31650@pd.tnic>
 <20131210021221.GA3800@dhcp-16-126.nay.redhat.com>
 <20131211102025.GB19196@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131211102025.GB19196@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 11, 2013 at 10:20:25AM +0000, Matt Fleming wrote:
> This needs reviewing by at least one of the x86 folks, but it
> certainly makes sense to me.

Ingo told me yesterday, it makes sense too. I'd guess we can try it.
FWIW, all callers of early_memremap use the memory they get remapped as
normal memory so we should be safe.

Maybe this whole discussion should be noted down in the commit message
so that people know.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
