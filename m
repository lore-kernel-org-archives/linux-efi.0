From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Tue, 29 Sep 2015 17:31:00 +0800
Message-ID: <20150929093100.GF30623@dhcp-129-73.nay.redhat.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com>
 <20150927104014.GA7631@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150927104014.GA7631@pd.tnic>
Sender: stable-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-efi@vger.kernel.org

On 09/27/15 at 12:40pm, Borislav Petkov wrote:
> On Sun, Sep 27, 2015 at 09:06:44AM +0200, Ingo Molnar wrote:
> > Could we please re-list all the arguments pro and contra of 1:1 physical mappings, 
> > in a post that also explains the background so that more people can chime in, not 
> > just people versed in EFI internals? It's very much possible that a bad decision 
> > was made.
> 
> The main reason why we did the additional, top-down mapping was kexec
> kernel wanting to use UEFI runtime facilities too and the braindead
> design of SetVirtualAddressMap() being callable only once per system
> boot. So we had to have stable mappings which are valid in the kexec-ed
> kernel too.
> 
> But this was long time ago and I most certainly have forgotten all the
> details.
> 
> And now I'm wondering why didn't we do the 1:1 thing and rebuild the
> exact same EFI pagetable in the kexec-ed kernel? Because when we do
> an EFI call, we switch to the special pagetable so why didn't we make
> the kexec-ed kernel rebuild the 1:1 pagetable which it can use for EFI
> calls...
> 
> Hmm, again, I've forgotten a lot of details so I'm sure Matt will come
> in and say "No, you can't do that because..."
> 

http://permalink.gmane.org/gmane.linux.kernel.efi/822

And more replies here:
http://comments.gmane.org/gmane.linux.kernel.efi/820

Thanks
Dave
