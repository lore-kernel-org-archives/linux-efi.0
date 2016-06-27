From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v4 5/8] spi: add support for ACPI reconfigure notifications
Date: Mon, 27 Jun 2016 23:13:56 +0200
Message-ID: <CAJZ5v0gzw4oWicOE8yKPZCKR8r9MxpnaBUBgZXOTzkz8hc_BQw@mail.gmail.com>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
 <1466164336-9508-6-git-send-email-octavian.purdila@intel.com> <20160627141713.GW28202@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160627141713.GW28202@sirena.org.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>, Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Tirdea, Irina" <irina.tirdea@intel.com>, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 27, 2016 at 4:17 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jun 17, 2016 at 02:52:13PM +0300, Octavian Purdila wrote:
>
>> This patch adds supports for SPI device enumeration and removal via
>> ACPI reconfiguration notifications that are send as a result of an
>> ACPI table load or unload operation.
>
> I still have the same concern I've had all the way through here: this is
> very similar to the equivalent DT code but not quite, especially in
> regard to the OF_POPULATED flag which has no ACPI equivalent.  This
> gives us ACPI code which just looks like it's missing something.  I'd
> like to see the comparison at least covered in the changelog so people
> have something to refer to in future when trying to understand why
> things are done this way.

I agree here.

Tavi, please extend the changelog as requested by Mark.
