
#include "CvGameCoreDLL.h"

CivEffectTypes   CIV_EFFECT_DEFAULT_ALL      = NO_CIV_EFFECT;
CivEffectTypes   CIV_EFFECT_DEFAULT_EUROPEAN = NO_CIV_EFFECT;
CivEffectTypes   CIV_EFFECT_DEFAULT_NATIVE   = NO_CIV_EFFECT;
CivEffectTypes   CIV_EFFECT_DEFAULT_KING     = NO_CIV_EFFECT;
CivEffectTypes   CIV_EFFECT_DEFAULT_HUMAN    = NO_CIV_EFFECT;
CivEffectTypes   CIV_EFFECT_DEFAULT_AI       = NO_CIV_EFFECT;

HurryTypes       HURRY_GOLD                  = NO_HURRY;
HurryTypes       HURRY_IMMIGRANT             = NO_HURRY;
HurryTypes       NUM_HURRY_TYPES             = FIRST_HURRY;

BuildTypes       NUM_BUILD_TYPES             = FIRST_BUILD;
CivEffectTypes   NUM_CIV_EFFECT_TYPES        = FIRST_CIV_EFFECT;
CivicOptionTypes NUM_CIVICOPTION_TYPES       = FIRST_CIVICOPTION;
EraTypes         NUM_ERA_TYPES               = FIRST_ERA;
FatherTypes      NUM_FATHER_TYPES            = FIRST_FATHER;
TraitTypes       NUM_TRAIT_TYPES             = FIRST_TRAIT;
UnitTypes        NUM_UNIT_TYPES              = FIRST_UNIT;


void CvGlobals::postXMLLoad(bool bFirst)
{
	if (bFirst)
	{
		NUM_BUILD_TYPES          = static_cast<BuildTypes>         (m_paBuildInfo.size());
		NUM_CIV_EFFECT_TYPES     = static_cast<CivEffectTypes>     (m_paCivEffectInfo.size());
		NUM_CIVICOPTION_TYPES    = static_cast<CivicOptionTypes>   (m_paCivicOptionInfo.size());
		NUM_ERA_TYPES            = static_cast<EraTypes>           (m_aEraInfo.size());
		NUM_FATHER_TYPES         = static_cast<FatherTypes>        (m_paFatherInfo.size());
		NUM_HURRY_TYPES          = static_cast<HurryTypes>         (m_paHurryInfo.size());
		NUM_TRAIT_TYPES          = static_cast<TraitTypes>         (m_paTraitInfo.size());
		NUM_UNIT_TYPES           = static_cast<UnitTypes>          (m_paUnitInfo.size());

		for (HurryTypes eHurry = FIRST_HURRY; eHurry < NUM_HURRY_TYPES; ++eHurry)
		{
			const char *type = GC.getHurryInfo(eHurry).getType();
			if (strcmp(type, "HURRY_GOLD") == 0)
			{
				HURRY_GOLD = eHurry;
			}
			else if (strcmp(type, "HURRY_IMMIGRANT") == 0)
			{
				HURRY_IMMIGRANT = eHurry;
			}
		}

		FAssertMsg(HURRY_GOLD != NO_HURRY, "Missing xml entry");
		FAssertMsg(HURRY_IMMIGRANT != NO_HURRY, "Missing xml entry");


		int iCounter = 0;

		for (CivEffectTypes eCivEffect = FIRST_CIV_EFFECT; eCivEffect < NUM_CIV_EFFECT_TYPES; ++eCivEffect)
		{
			const char *szType = this->getCivEffectInfo(eCivEffect)->getType();

			if (strcmp(szType, "CIV_EFFECT_DEFAULT_ALL") == 0)
			{
				CIV_EFFECT_DEFAULT_ALL = eCivEffect;
			}
			else if (strcmp(szType, "CIV_EFFECT_DEFAULT_EUROPEAN") == 0)
			{
				CIV_EFFECT_DEFAULT_EUROPEAN = eCivEffect;
			}
			else if (strcmp(szType, "CIV_EFFECT_DEFAULT_NATIVE") == 0)
			{
				CIV_EFFECT_DEFAULT_NATIVE = eCivEffect;
			}
			else if (strcmp(szType, "CIV_EFFECT_DEFAULT_KING") == 0)
			{
				CIV_EFFECT_DEFAULT_KING = eCivEffect;
			}
			else if (strcmp(szType, "CIV_EFFECT_DEFAULT_HUMAN") == 0)
			{
				CIV_EFFECT_DEFAULT_HUMAN = eCivEffect;
			}
			else if (strcmp(szType, "CIV_EFFECT_DEFAULT_AI") == 0)
			{
				CIV_EFFECT_DEFAULT_AI = eCivEffect;
			}
			else
			{
				continue;
			}
			++iCounter;
			if (iCounter == 5)
			{
				// all found. No need to loop the rest
				break;
			}
		}
	}
	else // bFirst
	{
		// Now all xml data has been loaded
		this->m_pAutogeneratedCivEffect = new CivEffectInfo(true);
		
		// set up consumed yields for fast looping
		{
			BoolArray aYields(JIT_ARRAY_YIELD);

			for (UnitTypes eUnit = FIRST_UNIT; eUnit < NUM_UNIT_TYPES; ++eUnit)
			{
				CvUnitInfo &kUnit = GC.getUnitInfo(eUnit);

				for (YieldTypes eYield = FIRST_YIELD; eYield < NUM_YIELD_TYPES; ++eYield)
				{
					if (kUnit.getYieldDemand(eYield) > 0)
					{
						aYields.set(true, eYield);
					}
				}
			}
			m_acUnitYieldDemandTypes.assign(aYields);
		}
	}
}
