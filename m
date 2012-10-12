From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
Date: Fri, 12 Oct 2012 14:11:35 -0600
Message-ID: <1350072695.7065.71.camel@rhapsody>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
	 <1350068629.7065.58.camel@rhapsody>
	 <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-10-12 at 20:21 +0100, Matt Fleming wrote:
> This is a common idiom used throughout the kernel to simply error paths.
> As you noted, calling kfree(NULL) is harmless and there's certainly no
> need to worry about the overhead of calling kfree() without doing any
> freeing since the error path is also the slow path.

A "return -ENOMEM" looks simpler and easier to read to me, but that is a
subjective opinion :)

--
Khalid
