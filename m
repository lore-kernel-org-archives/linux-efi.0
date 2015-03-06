From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 01/15] x86, kaslr: Use init_size instead of run_size
Date: Fri, 6 Mar 2015 14:55:34 +0100
Message-ID: <20150306135534.GD4259@pd.tnic>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-2-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425456048-16236-2-git-send-email-yinghai@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 04, 2015 at 12:00:34AM -0800, Yinghai Lu wrote:
> commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> 
> introduced one run_size for kaslr.
> 
> We do not need to have home grown run_size.
> 
> We should use real runtime size (include copy/decompress) aka init_size

Why?

I can see why but you need to explain it here. Also, look at the
e6023367d779 commit message. Now this is how you do a commit message!
Especially if it is early boot code, you explain stuff. Junjie even went
the distance and did a nice graphic.

So please redo your commit message.

And saying it is trivial and obvious will not get you anywhere, as
you've noticed already.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
