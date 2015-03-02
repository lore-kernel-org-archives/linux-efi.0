From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Mon, 2 Mar 2015 15:53:13 +0100
Message-ID: <20150302145313.GC17532@pd.tnic>
References: <CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
 <20150301094557.GA7748@pd.tnic>
 <20150301152351.GA17391@gmail.com>
 <CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
 <20150301194904.GC7748@pd.tnic>
 <CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA@mail.gmail.com>
 <20150301202938.GD7748@pd.tnic>
 <CAE9FiQWqfpCg5reKP5TOv=8qJCLxqBDHCKAexH94avZ4b3=irQ@mail.gmail.com>
 <20150302085654.GA17532@pd.tnic>
 <CAE9FiQVS0ai2k-WNfsbwvOkj8YUxzaZJN5XDTMu1Ukhot7zOTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVS0ai2k-WNfsbwvOkj8YUxzaZJN5XDTMu1Ukhot7zOTw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 02, 2015 at 03:04:30AM -0800, Yinghai Lu wrote:
> We can not assume that range is safe to use.
> 
> Please check attach one that should fix the problem really.

Well, it seems to work here but it still doesn't look reliable enough to
me. And this addon_zo thing of arbitrary 256K is strange.

What we should do instead and IMHO is have a special setup_data section
located right above .text where struct setup_data things are put in so
that they never get overwritten. This should be the cleanest IMHO.

It is hpa's call in the end of the day anyway.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
