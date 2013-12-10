From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
Date: Wed, 11 Dec 2013 00:32:07 +0100
Message-ID: <20131210233207.GI31437@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 10, 2013 at 03:25:49PM -0800, Andrew Morton wrote:
> On Mon,  9 Dec 2013 17:42:13 +0800 Dave Young <dyoung@redhat.com> wrote:
> 
> > Here is the V5 patchset for supporting kexec kernel efi runtime.
> 
> It's unclear (to me) who's supposed to merge this lot.  It's a "kexec"
> patch which actually hits on efi and x86.
> 
> I grabbed them for some -next testing but won't be offended if someone
> else merges them ;)

I was under the impression that this should go through Matt's efi tree.
Oh, and we need to finish reviewing them so picking them up now would be
too premature, IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
