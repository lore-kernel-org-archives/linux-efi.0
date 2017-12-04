From: Joe Perches <joe@perches.com>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Sun, 03 Dec 2017 18:33:57 -0800
Message-ID: <1512354837.6321.41.camel@perches.com>
References: <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
         <20171129210848.GF6217@eros>
         <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
         <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
         <20171130163235.GA27849@kroah.com> <20171130171036.GB31817@kroah.com>
         <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
         <20171201094846.GE9353@kroah.com>
         <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
         <20171202222244.GA3799@codeblueprint.co.uk>
         <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204020216.GA2436@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-12-04 at 10:02 +0800, Dave Young wrote:
> I think 0400 is good enough for this issue.
> 
> Greg, would you like to agree add an extra macro like below?
[]
> -static struct map_attribute map_type_attr = __ATTR_RO(type);
> -static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
> -static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
> -static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
> -static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
> +static struct map_attribute map_type_attr = __ATTR_IRUSR(type);
> +static struct map_attribute map_phys_addr_attr   = __ATTR_IRUSR(phys_addr);
> +static struct map_attribute map_virt_addr_attr  = __ATTR_IRUSR(virt_addr);
> +static struct map_attribute map_num_pages_attr  = __ATTR_IRUSR(num_pages);
> +static struct map_attribute map_attribute_attr  = __ATTR_IRUSR(attribute);
>  
>  /*
>   * These are default attributes that are added for every memmap entry.
> --- linux-x86.orig/include/linux/sysfs.h
> +++ linux-x86/include/linux/sysfs.h
> @@ -112,6 +112,11 @@ struct attribute_group {
>  	.store	= _store,						\
>  }
>  
> +#define __ATTR_IRUSR(_name) {					

I'd much prefer __ATTR_0400(_name)
