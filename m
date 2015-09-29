From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Tue, 29 Sep 2015 12:24:48 +0200
Message-ID: <20150929102448.GA25560@pd.tnic>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com>
 <20150927104014.GA7631@pd.tnic>
 <20150929093100.GF30623@dhcp-129-73.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150929093100.GF30623@dhcp-129-73.nay.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 29, 2015 at 05:31:00PM +0800, Dave Young wrote:
> http://permalink.gmane.org/gmane.linux.kernel.efi/822
> 
> And more replies here:
> http://comments.gmane.org/gmane.linux.kernel.efi/820

Whatever we did think back then, it all is moot as long as some UEFI
vendors do funky crap or the spec has documentation holes.

So we need a reality check and just do exactly what the OS does with
which UEFI writers are testing with. Be it windoze, be it some open
firmware testing tool or whatever. Provided there's even a tool with
which UEFI validation is done and it is used by everybody...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
