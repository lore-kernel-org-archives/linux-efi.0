From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v3 4/8] i2c: add support for ACPI reconfigure notifications
Date: Wed, 15 Jun 2016 13:30:10 +0300
Message-ID: <CAE1zotLFtzfOrfmiRaewzdctD4UDPa8pJ6fVC34C8XRrArb5UQ@mail.gmail.com>
References: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
	<1465917446-14043-5-git-send-email-octavian.purdila@intel.com>
	<20160615062724.GB1344@tetsubishi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160615062724.GB1344@tetsubishi>
Sender: linux-acpi-owner@vger.kernel.org
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 15, 2016 at 9:27 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Tue, Jun 14, 2016 at 06:17:22PM +0300, Octavian Purdila wrote:
>> This patch adds supports for I2C device enumeration and removal via
>> ACPI reconfiguration notifications that are send as a result of an
>> ACPI table load or unload operation.
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>
> What happened to Mika's reviewed-by?
>

Missed that, I will send a new series soon to correct a bisectability
issues reported by kbuild and I'll add with Mika's reviewed-bys.
