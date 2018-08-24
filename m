From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Fri, 24 Aug 2018 21:17:49 +0200
Message-ID: <20180824191749.GA15489@kroah.com>
References: <20171215092305.994559179@linuxfoundation.org>
 <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <1535129126.2902.36.camel@codethink.co.uk>
 <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Guenter Roeck <linux@roeck-us.net>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 24, 2018 at 10:08:28AM -0700, Roland Dreier wrote:
> > See
> > <https://lore.kernel.org/lkml/1512686629.18523.217.camel@codethink.co.uk/T/#u>.
> 
> Thanks!  I'm not using SGI UV and I'm not using kexec, so I guess I
> sidestepped most of those issues.  Greg, I think we need to unrevert
> the cpa->pfn change (otherwise the L1TF fix probably gets pretty
> messy) and I guess pull in the other patches that Ben mentions.

Ok, so what patch should be reverted?  I'm seeing other reports of
problems all around this same area, but I can't figure out exactly what
to do.

Guenter, any ideas?

thanks,

greg k-h
