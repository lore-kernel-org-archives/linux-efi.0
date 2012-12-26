From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: efivarfs: unlinking open files results in spinlock corruption
Date: Wed, 26 Dec 2012 18:40:46 +0800
Message-ID: <50DAD42E.40700@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>  <1351237923-10313-2-git-send-email-matt@console-pimps.org>  <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>  <50D90E61.40702@redhat.com>  <1356408784.6113.68.camel@linux-s257.site>  <1356501732.6113.213.camel@linux-s257.site>  <50DAC19A.8060500@redhat.com> <1356516962.6113.232.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356516962.6113.232.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/26/2012 06:16 PM, joeyli wrote:
> I am checking the write/umount/mount/read problem on v3.8-rc1.
>
> The issue also can trigger by read the GHOST test file. When issue

True. But this reproducer is meant to be isolated from efivarfs_file_write
code path and reproduce a general locking problem.

I separately report the ghost file problem in 
http://thread.gmane.org/gmane.linux.kernel.efi/465

> happen, the size of test file is zero. The 'var->efivars' already set to
> NULL when issue reproduced, that's why we always got NULL pointer
> dereference when try to spin lock it.

efivars comes from private data of the file when it has been released.
It can be some random value instead of NULL, so we see the varying behavior.

> If we don't do umount/mount step, then everything is OK for we can
> create/delete test file many times. But, if we umount/mount efivarfs
> then more easy to trigger issue.

I confirm this.

--
Lingzhu Xiang
