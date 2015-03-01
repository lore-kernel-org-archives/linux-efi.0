From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sun, 1 Mar 2015 20:39:29 +0100
Message-ID: <20150301193929.GB7748@pd.tnic>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
 <1425176259-30087-2-git-send-email-yinghai@kernel.org>
 <CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
 <20150301094557.GA7748@pd.tnic>
 <20150301152351.GA17391@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150301152351.GA17391@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 01, 2015 at 04:23:51PM +0100, Ingo Molnar wrote:
> I think that's a different bug.
> 
> parse_kaslr_setup() is simply bogus, it does:
> 
>         kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));

Well, we found that while debugging the other issue too:

https://lkml.kernel.org/r/20150228105049.GA11038@pd.tnic

Scroll to the end.

> So I'm inclined to apply Yinghai's fix, with a better changelog that 
> explains what happened ...
> 
> Agreed?

Yes, this fix needs a commit message which actually explains what's it
fixing before it gets applied.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
