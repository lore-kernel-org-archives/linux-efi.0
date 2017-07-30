From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
Date: Sun, 30 Jul 2017 10:37:25 -0700
Message-ID: <20170730173725.GA20606@kroah.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
 <20170730153224.GA31755@kroah.com>
 <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org, "open list:TI WILINK WIRELES..." <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jul 30, 2017 at 08:26:48PM +0300, Andy Shevchenko wrote:
> On Sun, Jul 30, 2017 at 6:32 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Wed, Jul 26, 2017 at 01:01:41PM +0300, Andy Shevchenko wrote:
> >> On Wed, 2017-07-19 at 21:28 +0300, Andy Shevchenko wrote:
> >> > There are new types and helpers that are supposed to be used in new
> >> > code.
> >> >
> >> > As a preparation to get rid of legacy types and API functions do
> >> > the conversion here.
> >> >
> >> > While here, re-indent couple of lines to increase readability.
> >>
> >> This looks like no user space UUID API is involved, can be routed via
> >> either tree (uuid or staging).
> >>
> >> Anyone to comment?
> >
> > Doesn't apply to the staging tree at all :(
> 
> No surprises, it was cooked against uuid tree in the first place.
> If you agree to take it through staging tree I will prepare a rebased version.
> Does it sound good?

You can take it through the uuid tree if it's easier for you, but then
someone will have to deal with the merge issues...

If it's easier, I can take it to prevent the merge problems.

thanks,

greg k-h
