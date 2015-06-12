From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 06/10] x86/asm/efi: Fix asmvalidate warnings for
 efi_stub_64.S
Date: Fri, 12 Jun 2015 21:24:41 +0200
Message-ID: <20150612192441.GL9084@pd.tnic>
References: <cover.1433937132.git.jpoimboe@redhat.com>
 <3e1d9ce523b3174a49b4317cd8b1b85dfd0c319a.1433937132.git.jpoimboe@redhat.com>
 <20150611131438.GB19243@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150611131438.GB19243@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, x86@kernel.org, live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 11, 2015 at 02:14:39PM +0100, Matt Fleming wrote:
> Yeah, fair enough. Though it's worth noting that because we're calling
> firmware functions, which use the Microsoft ABI, %rbp will be saved by
> the callee function if used.

Yeah, just looked at the spec.

But you know how we don't trust specs. So we get additional paranoid
security that callee won't futz with RBP because we save it before
calling. But we pay the additional penalty in the CONFIG_FRAME_POINTER
case.

Oh what the hell, the 3 additional insns shouldn't be noticeable.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
