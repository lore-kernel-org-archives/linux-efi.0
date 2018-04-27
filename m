From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v1] device property: Get rid of union aliasing
Date: Fri, 27 Apr 2018 12:56:08 +0200
Message-ID: <CAJZ5v0jgQwQCSqAfnap+pLBqBy-aMTORU=P3g5J77GK46-xOBQ@mail.gmail.com>
References: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 26, 2018 at 12:23 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The commit
>
>   318a19718261 ("device property: refactor built-in properties support")
>
> went way too far and brought a union aliasing. Partially revert it here
> to get rid of union aliasing.
>
> Note, Apple properties support is still utilizing this trick.

Can you please resend this with a slightly more detailed description
of what's going on in the changelog?

Someone reading git logs in the future would have a really hard time
with decoding the above, and the last sentence in particular. :-)
