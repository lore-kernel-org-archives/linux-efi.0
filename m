From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Date: Thu, 12 Dec 2013 21:36:56 +0100
Message-ID: <20131212203656.GC26927@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
 <20131212071337.GI3751@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131212071337.GI3751@dhcp-16-126.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 12, 2013 at 03:13:37PM +0800, Dave Young wrote:
> BTW, I will restructure the whole code when I move them to
> efi_kexec.c, so no worry about it? If you have strong opinion I can
> move them though.

Well, if it were me, I'd do it now so that it'll see more testing.
Later, it will be only a mechanical move of those functions which belong
to efi_kexec.c and won't need a second testing.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
