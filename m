From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Tue, 29 Sep 2015 18:19:13 -0700
Message-ID: <560B3891.8030900@zytor.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com> <560B34EF.8040408@zytor.com>
 <CALCETrVvwxZN95swaUDG2fkz9brWV3BQkfMDtLJXZkTRpe8nRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CALCETrVvwxZN95swaUDG2fkz9brWV3BQkfMDtLJXZkTRpe8nRg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-efi@vger.kernel.org

On 09/29/2015 06:16 PM, Andy Lutomirski wrote:
> 
> Can we at least do 1:1 without an offset on arm64?  Given that Linux
> seems to be more of a reference on arm64 than Windows is, maybe that
> would give everyone something vaguely sane to work with.
> 

I have no idea.  That's a question for the ARM folks.

	-hpa
