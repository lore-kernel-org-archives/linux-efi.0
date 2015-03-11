From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: efivarfs and writev() support
Date: Wed, 11 Mar 2015 13:42:26 +0000
Message-ID: <20150311134226.GB24174@codeblueprint.co.uk>
References: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33E85F72-FCA0-4DF7-B9E1-46D36244FCA3@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>, Al Viro <viro@ZenIV.linux.org.uk>
List-Id: linux-efi@vger.kernel.org

On Sun, 08 Mar, at 03:24:09PM, Marcel Holtmann wrote:
> Hi,
> 
> it seems that efivarfs only supports readv(), but when it comes to
> writev(), I am getting an error. Is there any reason to not support
> vectored write on this filesystem? Especially with the uint32 header
> for each file, I think it would make perfect sense to support it.

What error are you seeing? I thought that the vfs fell back to a looped
write if the file system doesn't support .write_iter()?

But yes, we definitely should support writev().

-- 
Matt Fleming, Intel Open Source Technology Center
