From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Thu, 5 Feb 2015 14:09:35 +0800
Message-ID: <20150205060935.GA23096@dhcp-16-198.nay.redhat.com>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
 <20150205032504.GB1903@darkstar.redhat.com>
 <CAE9FiQWMt7Y=kwhUu5PxcPP1aDSKdK-LojJatn3WgWHmEj9tsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQWMt7Y=kwhUu5PxcPP1aDSKdK-LojJatn3WgWHmEj9tsQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 02/04/15 at 09:25pm, Yinghai Lu wrote:
> On Wed, Feb 4, 2015 at 7:25 PM, Dave Young <dyoung@redhat.com> wrote:
> >> After this patch, could use patched grub2-x86_64.efi to place
> >> kernel/boot_params/cmd_line/initrd all above 4G and execute the kernel
> >> above 4G.
> >
> > Can you share the grub2 patch for testing?
> 
> Please check attached 5 patches. last one is for debug purpose.
> 
> You need to apply them on top of
> 
> git://git.savannah.gnu.org/grub.git
> 
> plus  http://pkgs.fedoraproject.org/cgit/grub2.git/plain/0091-Add-support-for-linuxefi.patch

> Subject: [PATCH] update setup_header and boot_params to 2.12
> 
> the one that is used by kernel v3.8...

Thanks for quick feedback..
Dave
