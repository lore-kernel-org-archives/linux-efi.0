From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: efivarfs: guid part of filenames are case-insensitive is broken
Date: Wed, 06 Mar 2013 15:41:34 +0800
Message-ID: <5136F32E.7080501@redhat.com>
References: <CADzA9okmNOS429FJNEAMj7gUMKD9bU8jzznCoJ_=tyySGDE++A@mail.gmail.com>  <5135AEEB.9090408@redhat.com> <1362486844.15011.8.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362486844.15011.8.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/05/2013 08:34 PM, Matt Fleming wrote:
> Lingzhu, could you test the following patch? You seem to be particularly
> good at weeding out bugs in this code.

Yes, bug is fixed by the patch. The selftests cases also work fine.


Lingzhu Xiang
