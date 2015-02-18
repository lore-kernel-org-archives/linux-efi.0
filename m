From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Tue, 17 Feb 2015 23:29:54 -0800
Message-ID: <CAE9FiQW4BzZb7oaNZMC3X=UvsnZYVd4A7F=WxrituYdANn9b-w@mail.gmail.com>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
	<20150205032504.GB1903@darkstar.redhat.com>
	<CAE9FiQWMt7Y=kwhUu5PxcPP1aDSKdK-LojJatn3WgWHmEj9tsQ@mail.gmail.com>
	<20150205060935.GA23096@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150205060935.GA23096@dhcp-16-198.nay.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 4, 2015 at 10:09 PM, Dave Young <dyoung@redhat.com> wrote:
> On 02/04/15 at 09:25pm, Yinghai Lu wrote:
>> On Wed, Feb 4, 2015 at 7:25 PM, Dave Young <dyoung@redhat.com> wrote:
>> >> After this patch, could use patched grub2-x86_64.efi to place
>> >> kernel/boot_params/cmd_line/initrd all above 4G and execute the kernel
>> >> above 4G.
>> >
>> > Can you share the grub2 patch for testing?
>>
>> Please check attached 5 patches. last one is for debug purpose.
>>
>> You need to apply them on top of
>>
>> git://git.savannah.gnu.org/grub.git
>>
>> plus  http://pkgs.fedoraproject.org/cgit/grub2.git/plain/0091-Add-support-for-linuxefi.patch
>

FYI, I put those patches together with patches that extend grub2 to load
kernel/initrd above 4G into github tree.

https://github.com/yhlu/grub2.git

Thanks

Yinghai
