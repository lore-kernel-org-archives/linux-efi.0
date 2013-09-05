From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI stub boots only with setup_efi_pc() commented
Date: Thu, 5 Sep 2013 09:29:24 +0100
Message-ID: <20130905082924.GI28598@console-pimps.org>
References: <CA+n4xYYJhoXp6KSeROda9ErrXZ0hFEBM-x-0Obvk3fmHwABfKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+n4xYYJhoXp6KSeROda9ErrXZ0hFEBM-x-0Obvk3fmHwABfKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Clea F. Rees" <reescf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 03 Aug, at 12:06:23AM, Clea F. Rees wrote:
> Matt Fleming asked me to email describing a problem I am experiencing
> with the EFI stub loader. Matt has been trying to diagnose the cause
> of consistent failures of the stub loader in recent kernels on my
> machine.
> 
> Background: All kernels I tried in 3.7.* booted fine using the stub
> loader (via rEFInd). No kernels tried from 3.8.* through 3.9.* and now
> into 3.10.* boot using the stub loader. None of the workarounds which
> others have used work for me. The problem is reproducible using a
> direct NVRAM entry rather than rEFInd. All kernels boot fine with
> GRUB.
> 
> The problem is reproducible with a kernel compiled from git. A series
> of experiments (following Matt's instructions) have determined that
> commenting out the call to setup_efi_pc() in eboot.c makes the kernels
> boot.
> 
> I would be happy to provide any further information which might be
> helpful or to run further tests.

Sorry for the delay in replying to this.

Does your machine hang during setup_efi_pci() or later on in boot?

-- 
Matt Fleming, Intel Open Source Technology Center
