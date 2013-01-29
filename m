From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/efivarfs: Add create-read test
Date: Tue, 29 Jan 2013 11:30:32 +0800
Message-ID: <51074258.4080705@redhat.com>
References: <1359240460.11991.960193311372.3.gpush@pororo>  <5106603C.5050309@redhat.com> <1359376629.8282.18.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359376629.8282.18.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/28/2013 08:37 PM, Matt Fleming wrote:
> I was the one who originally suggested using EIO for reading a variable
> that hasn't hit the backing store, mainly because it simplified the
> EFI_NOT_FOUND logic, and I felt that reading from a non-existent
> variable should be an error condition. But I can see the case for
> returning zero instead.

I agree translating EFI_NOT_FOUND to EIO is generally a good choice.
But in the special case of an uncommitted empty file, kernel can avoid
reading the expectedly non-existent variable and instead return
EOF directly.

Yes, empty files are uncommitted and will go away after reboot anyway,
regardless of EIO or not. Users have to know this.
