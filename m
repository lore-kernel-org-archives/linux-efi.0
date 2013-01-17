From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efivarfs: Delete dentry from dcache in efivarfs_file_write()
Date: Thu, 17 Jan 2013 17:37:30 +0800
Message-ID: <50F7C65A.7030308@canonical.com>
References: <1358408353-24497-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358408353-24497-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

> Unlike the unlink path that is called from the VFS layer, we need to
> call d_delete() ourselves when a variable is deleted in
> efivarfs_file_write().
>
> Failure to do so means we can access a stale struct efivar_entry when
> reading/writing the file, which can result in the following oops,

I still get an oops from Linghu Xiang's open/unlink test with this patch 
applied, running on OVMF. I'll investigate further..

Cheers,


Jeremy
