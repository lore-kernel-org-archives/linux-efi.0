From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1] device property: Get rid of union aliasing
Date: Thu, 26 Apr 2018 14:54:28 +0200
Message-ID: <20180426125428.GA8975@kroah.com>
References: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 26, 2018 at 01:23:56PM +0300, Andy Shevchenko wrote:
> The commit
> 
>   318a19718261 ("device property: refactor built-in properties support")
> 
> went way too far and brought a union aliasing. Partially revert it here
> to get rid of union aliasing.

What is "union aliasing"?  And why is it bad?

> Note, Apple properties support is still utilizing this trick.

So you are breaking something now?

What exactly is this fixing?

greg k-h
