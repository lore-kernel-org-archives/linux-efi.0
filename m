From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sun, 1 Mar 2015 11:27:48 -0800
Message-ID: <CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
	<1425176259-30087-2-git-send-email-yinghai@kernel.org>
	<CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
	<20150301094557.GA7748@pd.tnic>
	<20150301152351.GA17391@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150301152351.GA17391@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 1, 2015 at 7:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I think that's a different bug.
>
> parse_kaslr_setup() is simply bogus, it does:
>
>         kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
>
> which makes no sense whatsoever: it randomly enables (or disables,
> depending on the physical address of the setup page) KASLR when it
> meets a SETUP_KASLR record.
>

Yes, you are right.

there are 8 patches in this series.
  x86, kaslr: get kaslr_enabled back correctly
  x86: Kill E820_RESERVED_KERN
  x86, efi: copy SETUP_EFI data and access directly
  x86, of: let add_dtb reserve by itself
  x86, boot: Add add_pci handler for SETUP_PCI
  x86: kill not used setup_data handling code
  x86, pci: convert SETUP_PCI data to list
  x86, pci: export SETUP_PCI data via sysfs

other 7 should also address the problem in
   http://lkml.kernel.org/r/1424929021.10337.24.camel@intel.com

the root cause is E820_RESERVED_KERN and setup_data handling
will make E820 are not page aligned anymore.

We should change setup_data handling.

Please check updated version at

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-4.0

(with a fix for config without CONFIG_PCI).

Thanks

Yinghai
