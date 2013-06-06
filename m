From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 22:27:17 +0200
Message-ID: <20130606202717.GP20972@pd.tnic>
References: <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
 <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
 <20130606201828.GA3950@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130606201828.GA3950@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>, Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 09:18:28PM +0100, Matthew Garrett wrote:
> kexec seems like a lower priority than compatibility. Perhaps keep the
> efi argument for people who want to use kexec?

This is what I currently have in the code: if you boot with efi=1:1_map,
you get them.

> hpa suggested allocating a fixed high area for UEFI mappings, which
> would also solve this.

I guess we can do that too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
