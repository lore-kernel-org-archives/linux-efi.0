From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 3/7] x86, boot: Don't overlap VO with ZO data
Date: Tue, 10 Mar 2015 16:21:37 +0100
Message-ID: <20150310152137.GI3535@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-4-git-send-email-yinghai@kernel.org>
 <20150310093430.GC3535@pd.tnic>
 <CAE9FiQWauOdsZ=CBcVHfqTik1ePvW51uH7yy29MSvafOABTWZA@mail.gmail.com>
 <20150310151035.GG3535@pd.tnic>
 <CAE9FiQVy47PnXdd=c_st7OSatFQcvwfzk8XWej=9KUTnRyxKPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVy47PnXdd=c_st7OSatFQcvwfzk8XWej=9KUTnRyxKPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 08:17:01AM -0700, Yinghai Lu wrote:
> Make it not confusing.
> 
> ZO: arch/x86/boot/compressed/vmlinux
> VO: vmlinux
> 
> setup + ZO ==> bzImage.
> 
> compressed kernel is just compressed VO.

So the two end up being the "compressed kernel" and "kernel proper".

And then the subject turns into

"Don't overlap kernel proper's brk with the compressed kernel's data section"

Does that still confuse you?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
