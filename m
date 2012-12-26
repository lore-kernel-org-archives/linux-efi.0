From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 17/20] efivarfs: Replace magic number with sizeof(attributes)
Date: Wed, 26 Dec 2012 17:24:34 +0800
Message-ID: <50DAC252.5030308@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org> <1351237923-10313-18-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-18-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/26/2012 03:52 PM, Matt Fleming wrote:
> From: Matt Fleming<matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Seeing "+ 4" littered throughout the functions gets a bit
> confusing. Use "sizeof(attributes)" which clearly explains what
> quantity we're adding.
>
> Acked-by: Jeremy Kerr<jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Matt Fleming<matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks like one +4 got left behind, in efivarfs_fill_super

		i_size_write(inode, size+4);


--
Lingzhu Xiang
