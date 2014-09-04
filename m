From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Thu, 4 Sep 2014 22:29:25 +0100
Message-ID: <20140904212925.GL3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5408D299.5000300@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>, Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
> 
> I am fine with this patch, but at the same time I do want to note that
> there is an alternative to double-buffer the patch and/or (if that
> applies to the buggy BIOS) round up the size of the target buffer.

I'm not sure that rounding up the size of the target buffer will
workaround this issue correctly.

As far as I know, the only thing that Mantas tried was rounding up the
size of the source file, by padding it.

Laszlo, is there anything we can do in the kernel to avoid the EDK2 bug
you fixed here,

  https://github.com/tianocore/edk2/commit/4e39b75e

such as lying about the number of bytes we're trying to read or
allocating a bigger target buffer than we actually need?

Assuming of course, that the bug that Laszlo fixed and the bug that
Mantas is hitting are one and the same.

-- 
Matt Fleming, Intel Open Source Technology Center
