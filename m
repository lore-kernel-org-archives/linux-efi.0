From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sun, 1 Mar 2015 16:23:51 +0100
Message-ID: <20150301152351.GA17391@gmail.com>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
 <1425176259-30087-2-git-send-email-yinghai@kernel.org>
 <CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
 <20150301094557.GA7748@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150301094557.GA7748@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


(Cc:-ed Jiri and Kees as well.)

* Borislav Petkov <bp@suse.de> wrote:

> On Sat, Feb 28, 2015 at 06:40:39PM -0800, Yinghai Lu wrote:
> >
> > oh, no. the offending commit already got into linus tree.
> 
> We're working on it, follow this thread:
> 
> http://lkml.kernel.org/r/1424929021.10337.24.camel@intel.com

I think that's a different bug.

parse_kaslr_setup() is simply bogus, it does:

        kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));

which makes no sense whatsoever: it randomly enables (or disables, 
depending on the physical address of the setup page) KASLR when it 
meets a SETUP_KASLR record.

So I'm inclined to apply Yinghai's fix, with a better changelog that 
explains what happened ...

Agreed?

Thanks,

	Ingo
