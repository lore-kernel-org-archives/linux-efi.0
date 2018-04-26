From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v1] device property: Get rid of union aliasing
Date: Thu, 26 Apr 2018 15:05:05 +0200
Message-ID: <CAJZ5v0huZAZjRDSkgR+z8XqLShoyy24arevD3oiwn7GPHRid+g@mail.gmail.com>
References: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com> <20180426125428.GA8975@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426125428.GA8975@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 26, 2018 at 2:54 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 26, 2018 at 01:23:56PM +0300, Andy Shevchenko wrote:
>> The commit
>>
>>   318a19718261 ("device property: refactor built-in properties support")
>>
>> went way too far and brought a union aliasing. Partially revert it here
>> to get rid of union aliasing.
>
> What is "union aliasing"?  And why is it bad?
>
>> Note, Apple properties support is still utilizing this trick.
>
> So you are breaking something now?
>
> What exactly is this fixing?

A device properties framework change that went in through my tree.

I'll take care of this, but I agree that the commit log is not
particularly useful.

Cheers,
Rafael
