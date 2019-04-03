From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 1/2] efi: Fix cast to pointer from integer of different
 size in TPM log code
Date: Wed, 3 Apr 2019 09:51:54 -0700
Message-ID: <CACdnJusiCSH93cz+Q3yH01HBfDbVRQdO6JNCNOJwqt9Uqj_Qsw@mail.gmail.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
 <20190402215556.257406-2-matthewgarrett@google.com> <89e1cf4093d7405987c55f682519f9fc@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <89e1cf4093d7405987c55f682519f9fc@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "roberto.sassu@huawei.com" <roberto.sassu@huawei.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tweek@google.com" <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 3, 2019 at 6:41 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Matthew Garrett
> > Sent: 02 April 2019 22:56
> >
> > 8bfcff4a6a1d9d7226bb63a7da758b82d9ab4373 introduced a cast from
> > efi_physical_address_t to (void *), which are different sizes on 32-bit.
> > Fix that. Caught by the 0-day test bot.
>
> Casting a physical address to 'void *' seems completely wrong.
> Also you'd need a guarantee that the address was below 4G or the result
> is meaningless.
> Looks to me like something is using the wrong types somewhere.

We're in UEFI here, not the kernel proper - the firmware functions we
call give us back physical addresses, and we're operating with a 1:1
mapping. long is 64 bit on 64 bit systems, and on 32 bit systems we've
already asserted that all firmware resources are under 4GB (obviously
we're going to have a bad time if they're not, but there's not really
anything we can do about that)
