From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sun, 1 Mar 2015 12:41:10 -0800
Message-ID: <CAE9FiQWqfpCg5reKP5TOv=8qJCLxqBDHCKAexH94avZ4b3=irQ@mail.gmail.com>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
	<1425176259-30087-2-git-send-email-yinghai@kernel.org>
	<CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
	<20150301094557.GA7748@pd.tnic>
	<20150301152351.GA17391@gmail.com>
	<CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
	<20150301194904.GC7748@pd.tnic>
	<CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA@mail.gmail.com>
	<20150301202938.GD7748@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150301202938.GD7748@pd.tnic>
Sender: linux-pci-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 1, 2015 at 12:29 PM, Borislav Petkov <bp@suse.de> wrote:
> On Sun, Mar 01, 2015 at 12:24:08PM -0800, Yinghai Lu wrote:
>> static allocation in misc.c can not be used to kernel/head_64.S stage safely.
>
> Correct. One possibility that works is sticking it right below
> LOAD_PHYSICAL_ADDR:
>
> +static void add_kaslr_setup_data(struct boot_params *params,
> +                                u8 *output, __u8 enabled)
>  {
> +       /*
> +        * Stick it right under LOAD_PHYSICAL_ADDR
> +        */
> +       ksd = (struct setup_data *)(output - 2 * sizeof(struct setup_data));
>
> output is LOAD_PHYSICAL_ADDR AFAICT and is the minimum kASLR considers
> so right below it should work:

Does not look safe yet...

Let me think about it more.

Thanks

Yinghai
