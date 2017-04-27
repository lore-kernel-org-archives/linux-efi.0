From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Thu, 27 Apr 2017 14:55:14 +0100
Message-ID: <CAKv+Gu_n7xP-2RtF44GVzwyoMXDOeF-bR43yStwp2y+oBNs4jg@mail.gmail.com>
References: <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon> <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org> <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
 <20170410165328.GA5248@red-moon> <CAKv+Gu-AN-OwnAJG5dt0Qg4GU8HxZBowTSA0H3LhNA3nHfrsQg@mail.gmail.com>
 <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg@mail.gmail.com> <20170423014546.GA2704@dhcp-whq-twvpn-1-vpnpool-10-159-153-149.vpn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170423014546.GA2704-HmG2f/OLMhfd32I7TRUmRQWg3BAJk+jzdezBB/11ZoCIZ3GwZIjcak9v6f1uFnsJ2SarAXORi/o@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 April 2017 at 02:45, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Apr 10, 2017 at 06:29:27PM +0100, Ard Biesheuvel wrote:
>>  /*
>> @@ -208,8 +208,8 @@ struct pci_bus *pci_acpi_scan_root(struct
>> acpi_pci_root *root)
>>         if (!bus)
>>                 return NULL;
>>
>> -       pci_bus_size_bridges(bus);
>> -       pci_bus_assign_resources(bus);
>> +       pci_assign_unassigned_root_bus_resources(bus);
>> +       pci_bus_claim_resources(bus);
>>
>>         list_for_each_entry(child, &bus->children, node)
>>                 pcie_bus_configure_settings(child);
>>
>
> looks like those two lines are reversed. you should use:
>                 pcibios_resource_survey_bus(bus);
>                 pci_assign_unassigned_root_bus_resources(bus);
>
> please check x86 pcibios_resource_survey_bus() definition in
>         arch/x86/pci/i386.c
>
> but pci_bus_claim_resources() should work too.
>

Thanks Yinghai

pcibios_resource_survey_bus() is actually an empty function on arm64,
but I guess that is where logic should go that checks the state of the
BARs before trying to claim anything?
