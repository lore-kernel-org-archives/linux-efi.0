From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 0/6][RFC] Add EFI secure key to key retention service
Date: Mon, 6 Aug 2018 00:31:39 +0800
Message-ID: <20180805163139.GB27062@linux-l9pv.suse>
References: <20180805032119.20485-1-jlee@suse.com>
 <CAKv+Gu81vEGNggcWv1NyPJsMeK0HRi_DanH2+Z_4metoNG=txA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu81vEGNggcWv1NyPJsMeK0HRi_DanH2+Z_4metoNG=txA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, keyrings@vger.kernel.org, linux-integrity <linux-integrity@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Sun, Aug 05, 2018 at 09:25:56AM +0200, Ard Biesheuvel wrote:
> Hello Chun,yi,
> 
> On 5 August 2018 at 05:21, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > When secure boot is enabled, only signed EFI binary can access
> > EFI boot service variable before ExitBootService. Which means that
> > the EFI boot service variable is secure.
> >
> 
> No it, isn't, and this is a very dangerous assumption to make.
> 
> 'Secure' means different things to different people. 'Secure boot' is
> a misnomer, since it is too vague: it should be called 'authenticated
> boot', and the catch is that authentication using public-key crypto
> does not involve secrets at all. The UEFI variable store was not
> designed with confidentiality in mind, and assuming [given the
> reputation of EFI on the implementation side] that you can use it to
> keep secrets is rather unwise imho.
>

I agreed with you. Especially I can't refute the part of EFI
implementation, manufacturers can not be fully trusted. 

I am thinking a case... Some machines provide setup mode. If user
earses all manufacturer's reloaded keys and only enrolls their own
key. Which means that user fully controls the authentication
environment. Then the EFI boot service varible can be trusted by
the user. But this case is too strict for normal user.

Thanks for your review and comments. I will think more about your
suggestions.

Joey Lee  
